//
//  Actor.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/22.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

/// 演员类别
public enum ActorClassify: Hashable {
    public typealias T = Any
    
    case loading
    case hudText
    case alert
    case sheet
    /// 继承UIview 的自定义视图都为此类型，根据类名区分
    case other(T.Type)

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .other(let t):
            hasher.combine("custom\(t.self)".hashValue)
        default:
            break
        }
    }

    public static func ==(lhs: ActorClassify, rhs: ActorClassify) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

/**
 演员  相由心生
 */
public protocol Actor {
    var face: UIView { get }
    var animationLayer: CALayer? { get }
    var classify: ActorClassify { get }
    /// 重力效应
    var showMotionEffect: Bool { get }
}

public extension Actor {
    var showMotionEffect: Bool {
        return false
    }
}

public protocol FilmProgressDelegate {
    
    func progressChanged(progress: Double, on: UIView)
}

extension UIView: Actor {
    public var face: UIView {
        return self
    }
    
    public var animationLayer: CALayer? {
        return self.layer
    }
    
    public var classify: ActorClassify {
        return .other(Self.self)
    }
}

// MARK: - HUD
public enum HUDContent {
    case label(String?, textColor: UIColor = .white, font: UIFont? = nil)
    case activityIndicator
    case loading(image: UIImage, title: String?)
    case progress(veil: ProgressRingVeil)
}

open class HUD: Actor {
    struct Metric {
        static let labelTextFont =  UIFont.systemFont(ofSize: 15)
        static let indicatorSize = CGSize(width: 80.0, height: 80.0)
        
        static let maxContentHeight: CGFloat = 200
        static let minContentHeight: CGFloat = 60
        
        static let edgePadding: CGFloat = 10
    }
    
    public var content: HUDContent
    
    public init(content: HUDContent) {
        self.content = content
        switch content {
        case .label:
            self._classify = .hudText
        default:
            self._classify = .loading
        }
    }
    
    private var _animationLayer: CALayer?
    public var animationLayer: CALayer? {
        return _animationLayer
    }
    private var _classify: ActorClassify = .hudText
    public var classify: ActorClassify {
        return _classify
    }
    
    public var face: UIView {
        let face = UIView()
        face.clipsToBounds = true
        face.contentMode = .center
        
        switch self.content {
        case .label(let text, let color, let font):
            
            let textSize = text?.yf_size(titleFont: font ?? Metric.labelTextFont, maxWidth: UIScreen.main.bounds.width - 80) ?? CGSize.zero
            let height = min(Metric.maxContentHeight, max(textSize.height + Metric.edgePadding * 2, Metric.minContentHeight))
            face.frame.size = CGSize(width: textSize.width + Metric.edgePadding * 2, height: height)
            
            let label = UILabel()
            label.textAlignment = .center
            label.font = font ?? Metric.labelTextFont
            label.text = text
            label.textColor = color
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 3
            let padding: CGFloat = Metric.edgePadding
            label.frame = face.bounds.insetBy(dx: padding, dy: padding)
            
            face.addSubview(label)
            
        case .activityIndicator:
            
            face.frame.size = Metric.indicatorSize
            let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicator.color = UIColor.white
            activityIndicator.center = face.center
            activityIndicator.startAnimating()
            
            face.addSubview(activityIndicator)
            
        case .progress(let veil):
            let veilSize = veil.frame.size
            if veilSize.width <= 30 {
                veil.frame.size = CGSize(width: 80.0, height: 80.0)
            }
            let realSize = veil.frame.size.width + 15
            face.frame.size = CGSize(width: realSize, height: realSize)
            veil.center = CGPoint(x: realSize / 2, y: realSize / 2)
            
            face.addSubview(veil)
            
        case let .loading(image, title):
            face.frame.size = CGSize(width: 100.0, height: 90.0)
            
            let imageLayer = CALayer()
            imageLayer.contents = image.cgImage
            let imageSize = min(image.size.width, 40)
            imageLayer.frame = CGRect(x: 50 - imageSize / 2, y: 15, width: imageSize, height: imageSize)
            
            face.layer.addSublayer(imageLayer)
            self._animationLayer = imageLayer
            
            if let title = title {
                let label = UILabel()
                label.frame = CGRect(x: 0, y: 5 + imageLayer.frame.maxY, width: 100.0, height: 30.0)
                label.font = UIFont.systemFont(ofSize: 12)
                label.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                label.text = title
                label.textAlignment = .center
                label.numberOfLines = 2
                
                face.addSubview(label)
            }
        }
        
        return face
    }
}

// MARK: - Alert
public struct AlertAction {
    private var _title: String?
    
    public init(title: String?, handler: (() -> Swift.Void)? = nil) {
        _title = title
        _handler = handler
    }
    
    public var isEnabled: Bool = true
    
    public var backgroundColor: UIColor?
    public var titleColor: UIColor?
    public var font: UIFont = UIFont.systemFont(ofSize: 16)
    
    public var title: String? {
        get { return _title }
    }
    
    var _handler: (() -> Swift.Void)?
}

private class ActionControl: UIButton {
    var action: AlertAction?
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    convenience init(action: AlertAction) {
        self.init()
        self.action = action
        
        let titleColor = action.titleColor ?? 0x202530.color
        backgroundColor = action.backgroundColor ?? .clear
        titleLabel?.font = action.font
        setTitleColor(titleColor, for: .normal)
        
        setTitle(action.title, for: .normal)
        addTarget(self, action: #selector(ActionControl.performAction), for: .touchUpInside)
    }
    
    func setupHighlightedStyle() {
        let highlightedView = UIView(frame: frame)
        highlightedView.backgroundColor = UIColor.init(white: 0.8, alpha: 0.3)
        UIGraphicsBeginImageContext(frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            highlightedView.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            setBackgroundImage(image, for: .highlighted)
            UIGraphicsEndImageContext()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupHighlightedStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func performAction() {
        if let action = action {
            action._handler?()
        }
    }
}

public struct AlertConfig {
    public var titleFont = UIFont.boldSystemFont(ofSize: 18)
    public var textFont = UIFont.systemFont(ofSize: 16)
    public var titleColor = 0x111111.color
    public var textColor = 0x111111.color
    public var contentWidth = UIScreen.main.bounds.width - 40
    
    public static let `default`: AlertConfig = {
        let config = AlertConfig()
        return config
    }()
}

public enum Theme {
    case white
    case black
}

open class Alert: Actor {
    public var face: UIView {
        return contentView
    }
    
    public var animationLayer: CALayer? {
        return contentView.layer
    }
    
    public var classify: ActorClassify {
        return .alert
    }
    
    struct Metric {
        static func backgroundColor(with theme: Theme) -> UIColor {
            switch theme {
            case .white:
                return .white
            case .black:
                return 0x3B3D3F.color
            }
        }
        
        static func lineColor(with theme: Theme) -> UIColor {
            switch theme {
            case .white:
                return UIColor(white: 0, alpha: 0.1)
            case .black:
                return .white
            }
        }
        
        static let textFieldHeight: CGFloat = 40
        static let maxtTextHeight: CGFloat = 150
        static let actionHeight: CGFloat = 44
    }
    
    private let contentView = UIView()
    private var _actions = [AlertAction]()
    
    private var config = AlertConfig()
    open var actions: [AlertAction] {
        return _actions
    }
    
    private var _textFields = [UITextField]()
    open var textFields: [UITextField]? {
        return _textFields.isEmpty ? nil : _textFields
    }
    
    open var title: String?
    open var message: String?
    
    open var theme: Theme = .white {
        didSet { layoutUI() }
    }
    
    public init(title: String?, message: String?, config: AlertConfig = AlertConfig.default, theme: Theme = .white) {
        self.title = title
        self.message = message
        self.config = config
        self.theme = theme
    }
    
    open func setActions(_ actions: [AlertAction]) {
        _actions = actions
        layoutUI()
    }
    
    open func addTextField(configurationHandler: ((UITextField) -> Swift.Void)? = nil) {
        
        let textFiled = UITextField()
        configurationHandler?(textFiled)
        _textFields.append(textFiled)
    }
    
    public func layoutUI() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.backgroundColor = Metric.backgroundColor(with: theme)
        let width = min(config.contentWidth, UIScreen.main.bounds.width)
        let messageHeight = (message?.yf_size(titleFont: config.textFont, maxWidth: width - 48).height) ?? 0
        
        var lineY: CGFloat = 24
        
        let titleHeight = (title?.yf_size(titleFont: config.titleFont, maxWidth: width - 48).height) ?? 0
        let titleLable = UILabel()
        titleLable.numberOfLines = 0
        titleLable.text = title
        titleLable.textAlignment = .center
        titleLable.textColor = config.titleColor
        titleLable.font = config.titleFont
        titleLable.frame = CGRect(x: 24, y: lineY, width: width-48, height: titleHeight)
        
        contentView.addSubview(titleLable)
        if !(title?.isEmpty ?? true) {
            lineY += titleHeight + 24
        }
        
        let messageLable = UITextView() // UILabel()
        messageLable.text = message
        messageLable.textAlignment = .left
        messageLable.backgroundColor = .clear
        messageLable.font = config.textFont
        messageLable.showsVerticalScrollIndicator = false
        messageLable.isEditable = false
        messageLable.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        messageLable.numberOfLines = 0
        messageLable.textColor = config.textColor
        messageLable.isScrollEnabled = messageHeight > Metric.maxtTextHeight
        messageLable.frame = CGRect.init(x: 24, y: lineY, width: width-48, height: min(messageHeight, Metric.maxtTextHeight))
        
        contentView.addSubview(messageLable)
        lineY += min(messageHeight, Metric.maxtTextHeight) + 32
        
        let line = UIView()
        line.backgroundColor = Metric.lineColor(with: theme)
        contentView.addSubview(line)
        line.frame = CGRect.init(x: 16, y: lineY, width: width - 32, height: 0.5)
        lineY += 0.5
        
        textFields?.forEach({ (field) in
            field.frame = CGRect.init(x: 10, y: lineY, width: width-20, height: Metric.textFieldHeight)
            contentView.addSubview(field)
            lineY += Metric.textFieldHeight + 10
        })
        
        if actions.count == 2 {
            for (i, action) in actions.enumerated() {
                let actionButton = ActionControl(action: action)
                let actionWidth = width / 2 - 0.5
                let x = i == 0 ? actionWidth * CGFloat(i) : actionWidth * CGFloat(i) + 1
                actionButton.frame = CGRect.init(x: x, y: lineY, width: actionWidth, height: Metric.actionHeight)
                contentView.addSubview(actionButton)
                
                if i == 0 {
                    let line = UIView()
                    line.backgroundColor = Metric.lineColor(with: theme)
                    contentView.addSubview(line)
                    line.frame = CGRect.init(x: actionWidth, y: lineY, width: 0.5, height: Metric.actionHeight)
                }
            }
            lineY += Metric.actionHeight
        } else {
            for (i, action) in actions.enumerated() {
                if i > 0 {
                    let line = UIView()
                    line.backgroundColor = Metric.lineColor(with: theme)
                    contentView.addSubview(line)
                    line.frame = CGRect.init(x: 0, y: lineY, width: width, height: 1)
                    lineY += 1
                }
                
                let actionButton = ActionControl(action: action)
                actionButton.frame = CGRect.init(x: 0, y: lineY, width: width, height: Metric.actionHeight)
                contentView.addSubview(actionButton)
                lineY += Metric.actionHeight
            }
        }
        
        let totalHeight = lineY
        contentView.frame = CGRect(x: 0, y: 0, width: width, height: totalHeight)
    }
}

// MARK: - Sheet
open class Sheet: Actor {
    public var face: UIView {
        return contentView
    }
    
    public var animationLayer: CALayer? {
        return contentView.layer
    }
    
    public var classify: ActorClassify {
        return .sheet
    }
    
    struct Metric {
        static func backgroundColor(with theme: Theme) -> UIColor {
            switch theme {
            case .white:
                return .white
            case .black:
                return 0x1E222E.color
            }
        }
        
        static func lineColor(with theme: Theme) -> UIColor {
            switch theme {
            case .white:
                return 0xE9EBEF.color
            case .black:
                return 0x2B3145.color
            }
        }
        
        static func sepColor(with theme: Theme) -> UIColor {
            switch theme {
            case .white:
                return 0xE9EBEF.color
            case .black:
                return 0x12151F.color
            }
        }
        static let actionHeight: CGFloat = 54
    }
    
    private let contentView = UIView()
    private var _actions = [AlertAction]()
    
    open var actions: [AlertAction] {
        return _actions
    }
    
    open var cancelAction: AlertAction?
    
    open var theme: Theme = .white {
        didSet { layoutUI() }
    }
    
    public init(theme: Theme = .white) {
        self.theme = theme
    }
    
    open func setActions(_ actions: [AlertAction]) {
        _actions = actions
        layoutUI()
    }
    
    public func layoutUI() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.backgroundColor = Metric.backgroundColor(with: theme)
        let width = UIScreen.main.bounds.width
        var lineY: CGFloat = 0
        
        for (i, action) in actions.enumerated() {
            if i > 0 {
                let line = UIView()
                line.backgroundColor = Metric.lineColor(with: theme)
                contentView.addSubview(line)
                line.frame = CGRect.init(x: 0, y: lineY, width: width, height: 1)
                lineY += 1
            }
            
            let actionButton = ActionControl(action: action)
            actionButton.frame = CGRect.init(x: 0, y: lineY, width: width, height: Metric.actionHeight)
            contentView.addSubview(actionButton)
            lineY += Metric.actionHeight
        }
        
        if let cancel = cancelAction {
            let line = UIView()
            line.backgroundColor = Metric.sepColor(with: theme)
            contentView.addSubview(line)
            line.frame = CGRect.init(x: 0, y: lineY, width: width, height: 12)
            lineY += 12
            
            let actionButton = ActionControl(action: cancel)
            actionButton.frame = CGRect.init(x: 0, y: lineY, width: width, height: Metric.actionHeight)
            contentView.addSubview(actionButton)
            lineY += Metric.actionHeight
        }
        
        lineY += (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        let totalHeight = lineY
        contentView.frame = CGRect(x: 0, y: 0, width: width, height: totalHeight)
        let bounds = CGRect(origin: .zero, size: CGSize(width: width, height: totalHeight))
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        contentView.layer.mask = maskLayer
    }
}
