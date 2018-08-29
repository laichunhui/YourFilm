//
//  Actor.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/22.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

/**
    演员  相由心生
 */

public protocol ActorType {
    //    associatedtype E
    
    var face: UIView { get }
    
    //    func on(_ action: Action<E>)
}


public enum Action<Element> {
    case next(Element)
    case completed
}

public protocol FilmProgressDelegate {
    
    func progressChanged(progress: Double, on: UIView)
}


extension UIView: ActorType {
    public var face: UIView {
        return self
    }
}


//MARK: - HUD
public enum HUDContent {
    case label(String?)
    case image(UIImage?)
    
    case activityIndicator
    case progress
}

open class HUD: ActorType {
    struct Metric {
        static let labelTextFont =  UIFont.systemFont(ofSize: 15)
        static let indicatorSize = CGSize(width: 80.0, height: 80.0)
        
        static let maxContentHeight: CGFloat = 200
        static let minContentHeight: CGFloat = 80
    }
    
    public var progressVeil: MagicVeil?
    public var progress: Double = 0 {
        didSet {
            switch content {
            case .progress:
                progressVeil?.progress = progress
            default:
                break
            }
        }
    }
    
    open var content: HUDContent
    
    public init(content: HUDContent) {
        self.content = content
    }
    
    open var face: UIView {
        let face = UIView()
        face.alpha = 0.85
        face.clipsToBounds = true
        face.contentMode = .center
        
        switch self.content {
        case .label(let text):
            let textSize = text?.yf_size(titleFont: Metric.labelTextFont, maxWidth: UIScreen.main.bounds.width - 50) ?? CGSize.zero
            let height = min(Metric.maxContentHeight, max(textSize.height + 16, Metric.minContentHeight))
            face.frame.size = CGSize(width: textSize.width + 18, height: height)
            
            let label = UILabel()
                label.textAlignment = .center
                label.font = Metric.labelTextFont
                label.textColor = UIColor.black.withAlphaComponent(0.8)
                label.adjustsFontSizeToFitWidth = true
                label.numberOfLines = 5
                label.text = text
                let padding: CGFloat = 10.0
                label.frame = face.bounds.insetBy(dx: padding, dy: padding)
            
            face.addSubview(label)
        
        case .activityIndicator:
            face.frame.size = Metric.indicatorSize
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                activityIndicator.color = UIColor.black
                activityIndicator.center = face.center
                activityIndicator.startAnimating()
           
            face.addSubview(activityIndicator)
            
        case .progress:
            face.frame.size = CGSize(width: 100.0, height: 100.0)
           
            let veil = MagicVeil()
                veil.frame.size = CGSize(width: 80.0, height: 80.0)
                veil.center = CGPoint(x: 50, y: 50)
                veil.shouldShowGuide = true
                veil.lineWidth = 3.0
                veil.guideColor = UIColor.green
                veil.guideLineWidth = 8.0
                veil.colors = [UIColor.red, UIColor.black, UIColor.purple]
            
            progressVeil = veil
            face.addSubview(progressVeil!)
            
        default:
            break
        }
        
        return face
    }
}

//MARK: - Alert
public enum AlertStyle : Int {
    
    case actionSheet
    
    case alert
}

open class AlertAction: NSObject {
    private var _title: String?
    
    public init(title: String?, handler: ((AlertAction) -> Swift.Void)? = nil) {
        _title = title
        _handler = handler
    }
    
    open var isEnabled: Bool = true
    
    open var backgroundColor: UIColor = UIColor(yfHexValue: 0xFFFFFF, alpha: 0.3)
    open var titleColor: UIColor = UIColor(yfHexValue: 0x2492ED, alpha: 0.7)
    
    open var title: String? {
        get { return _title }
    }
    
     var _handler: ((AlertAction) -> Swift.Void)?
}


private class ActionControl: UIButton {
    var action: AlertAction?
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    convenience init(action: AlertAction) {
        self.init()
        
        self.action = action
        
        setTitle(action.title, for: .normal)
        setTitleColor(action.titleColor, for: .normal)
        backgroundColor = action.backgroundColor

        addTarget(self, action: #selector(ActionControl.performAction), for: .touchUpInside)
    }
    
    func setupHighlightedStyle() {
        let highlightedView = UIView(frame: frame)
        highlightedView.backgroundColor = UIColor.init(white: 0.9, alpha: 0.3)
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
            action._handler?(action)
        }
    }
}

open class AlertView: UIView {
    
    struct Metric {
        static let backgroundColor: UIColor = UIColor(yfHexValue: 0x66C7FF)
        static let titleBgColor: UIColor = UIColor(yfHexValue: 0x33A2FD, alpha: 0.7)
        
        static let titleFont = UIFont.boldSystemFont(ofSize: 16)
        static let textFont = UIFont.systemFont(ofSize: 14)
        
        static let width: CGFloat = 270
        static let titleHeight: CGFloat = 38
        static let textFieldHeight: CGFloat = 34
        static let actionHeight: CGFloat = 38
    }
    
    public convenience init(title: String?, message: String?, preferredStyle: AlertStyle) {
        self.init()
        
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
    }
    
    public init() {
        self.preferredStyle = .alert
        super.init(frame: CGRect.zero)
        backgroundColor = Metric.backgroundColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func addAction(_ action: AlertAction) {
        _actions.append(action)
        layoutUI()
    }
    private var _actions = [AlertAction]()
    open var actions: [AlertAction] {
        return _actions
    }
    
    open func addTextField(configurationHandler: ((UITextField) -> Swift.Void)? = nil) {
        
        let textFiled = UITextField()
        configurationHandler?(textFiled)
        _textFields.append(textFiled)
    }
    
    private var _textFields = [UITextField]()
    open var textFields: [UITextField]? {
        return _textFields.isEmpty ? nil : _textFields
    }
    
    open var title: String? {
        didSet { layoutUI() }
    }
    
    open var message: String? {
        didSet { layoutUI() }
    }
    
    var preferredStyle: AlertStyle
    
    func layoutUI() {
        subviews.forEach { $0.removeFromSuperview() }
        
        let width = Metric.width
        let messageHeight = (message?.yf_size(titleFont: Metric.textFont, maxWidth: Metric.width).height) ?? 0 + 20

        var lineY: CGFloat = 0
        
        let titleHeight = title == nil ? CGFloat(0) : Metric.titleHeight
        let titleLable = UILabel()
            titleLable.text = title
            titleLable.textAlignment = .center
            titleLable.backgroundColor = Metric.titleBgColor
            titleLable.textColor = UIColor.white
            titleLable.font = Metric.titleFont
            titleLable.frame = CGRect.init(x: 0, y: 0, width: width, height: titleHeight)
        
        
        addSubview(titleLable)
        lineY += titleHeight + 10
        
        let messageLable = UILabel()
            messageLable.text = message
            messageLable.font = Metric.textFont
            messageLable.textColor = UIColor.white
            messageLable.frame = CGRect.init(x: 16, y: lineY, width: width-32, height: messageHeight)
        
        addSubview(messageLable)
        lineY += messageHeight + 30
        
        textFields?.forEach({ (field) in
            field.frame = CGRect.init(x: 10, y: lineY, width: width-20, height: Metric.textFieldHeight)
            addSubview(field)
            lineY += Metric.textFieldHeight + 10
        })
        
        if actions.count == 2 {
            for (i, action) in actions.enumerated() {
                let actionButton = ActionControl.init(action: action)
                let actionWidth =  width / 2 - 0.5
                let x = i == 0 ? actionWidth * CGFloat(i) : actionWidth * CGFloat(i) + 1
                actionButton.frame = CGRect.init(x: x, y: lineY, width: actionWidth, height: Metric.actionHeight)
                
                addSubview(actionButton)
            }
            lineY += Metric.actionHeight
        }
        else {
            actions.forEach { (action) in
                let actionButton = ActionControl.init(action: action)
                actionButton.frame = CGRect.init(x: 0, y: lineY, width: width, height: Metric.actionHeight)
                
                addSubview(actionButton)
                lineY += Metric.actionHeight + 1
            }
        }
        
        let totalHeight = lineY
        layer.cornerRadius = 3
        clipsToBounds = true

        frame = CGRect(x: 0, y: 0, width: width, height: totalHeight)
    }
    
    @objc func performAction(at indext: Int) {
        if let action = actions.yf_Element(at: indext) {
            action._handler?(action)
        }
    }
}
