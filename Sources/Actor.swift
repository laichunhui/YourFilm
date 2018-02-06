//
//  Actor.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/22.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

struct RoleConfigs {
    struct HUD {
        static let labelTextFont =  UIFont.systemFont(ofSize: 15)
        static let indicatorSize = CGSize(width: 80.0, height: 80.0)
    }
    
    struct Alert {
        static let backgroundColor: UIColor = UIColor(syHexValue: 0x66C7FF)
        static let titleBgColor: UIColor = UIColor(syHexValue: 0x33A2FD, alpha: 0.7)
        
        static let titleFont = UIFont.boldSystemFont(ofSize: 16)
        static let textFont = UIFont.systemFont(ofSize: 14)
       
        static let width: CGFloat = 270
        static let titleHeight: CGFloat = 38
        static let textFieldHeight: CGFloat = 34
        static let actionHeight: CGFloat = 38
    }
}

/**
    演员  相由心生
 */

class Actor: RoleplayAble {
    var type = RoleType.custom
    
    var face: UIView {
        return UIView()
    }
    
    var progress: Double = 0
}


//MARK: - HUD
public enum HUDContent {
    case label(String?)
    case image(UIImage?)
    
    case activityIndicator
    case progress
}

open class HUD: RoleplayAble {
    public var type: RoleType {
        return RoleType.hud
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
            let textSize = text?.sy_size(titleFont: RoleConfigs.HUD.labelTextFont, maxWidth: UIScreen.main.bounds.width - 50) ?? CGSize.zero
            face.frame.size = CGSize(width: textSize.width + 18, height: textSize.height + 16)
            
            let label = UILabel().then {
                $0.textAlignment = .center
                $0.font = RoleConfigs.HUD.labelTextFont
                $0.textColor = UIColor.black.withAlphaComponent(0.8)
                $0.adjustsFontSizeToFitWidth = true
                $0.numberOfLines = 3
                
                $0.text = text
                let padding: CGFloat = 10.0
                $0.frame = face.bounds.insetBy(dx: padding, dy: padding)
            }
            face.addSubview(label)
        
        case .activityIndicator:
            face.frame.size = RoleConfigs.HUD.indicatorSize
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge).then {
                $0.color = UIColor.black
                $0.center = face.center
                $0.startAnimating()
            }
           
            face.addSubview(activityIndicator)
            
        case .progress:
            face.frame.size = CGSize(width: 100.0, height: 100.0)
           
            progressVeil = MagicVeil().then {
             
                $0.frame.size = CGSize(width: 80.0, height: 80.0)
                $0.center = CGPoint(x: 50, y: 50)
                
                $0.shouldShowGuide = true
                $0.lineWidth = 3.0
                $0.guideColor = UIColor.green
                $0.guideLineWidth = 8.0
                
                $0.colors = [UIColor.red, UIColor.black, UIColor.purple]
            }
        
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
    
    open var backgroundColor: UIColor = UIColor(syHexValue: 0xFFFFFF, alpha: 0.3)
    open var titleColor: UIColor = UIColor(syHexValue: 0x2492ED, alpha: 0.7)
    
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
    
    public convenience init(title: String?, message: String?, preferredStyle: AlertStyle) {
        self.init()
        
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
    }
    
    public init() {
        self.preferredStyle = .alert
        super.init(frame: CGRect.zero)
        backgroundColor = RoleConfigs.Alert.backgroundColor
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
    
    private var preferredStyle: AlertStyle
    
    func layoutUI() {
        subviews.forEach { $0.removeFromSuperview() }
        
        let width = RoleConfigs.Alert.width
        let messageHeight = (message?.sy_size(titleFont: RoleConfigs.Alert.textFont, maxWidth: RoleConfigs.Alert.width).height) ?? 0 + 20

        var lineY: CGFloat = 0
        
        let titleHeight = title == nil ? CGFloat(0) : RoleConfigs.Alert.titleHeight
        let titleLable = UILabel().then {
            $0.text = title
            $0.textAlignment = .center
            $0.backgroundColor = RoleConfigs.Alert.titleBgColor
            $0.textColor = UIColor.white
            $0.font = RoleConfigs.Alert.titleFont
            $0.frame = CGRect.init(x: 0, y: 0, width: width, height: titleHeight)
        }
        
        addSubview(titleLable)
        lineY += titleHeight + 10
        
        let messageLable = UILabel().then {
            $0.text = message
            $0.font = RoleConfigs.Alert.textFont
            $0.textColor = UIColor.white
            $0.frame = CGRect.init(x: 16, y: lineY, width: width-32, height: messageHeight)
        }
        
        addSubview(messageLable)
        lineY += messageHeight + 30
        
        textFields?.forEach({ (field) in
            field.frame = CGRect.init(x: 10, y: lineY, width: width-20, height: RoleConfigs.Alert.textFieldHeight)
            addSubview(field)
            lineY += RoleConfigs.Alert.textFieldHeight + 10
        })
        
        if actions.count == 2 {
            for (i, action) in actions.enumerated() {
                let actionButton = ActionControl.init(action: action)
                let actionWidth =  width / 2 - 0.5
                let x = i == 0 ? actionWidth * CGFloat(i) : actionWidth * CGFloat(i) + 1
                actionButton.frame = CGRect.init(x: x, y: lineY, width: actionWidth, height: RoleConfigs.Alert.actionHeight)
                
                addSubview(actionButton)
            }
            lineY += RoleConfigs.Alert.actionHeight
        }
        else {
            actions.forEach { (action) in
                let actionButton = ActionControl.init(action: action)
                actionButton.frame = CGRect.init(x: 0, y: lineY, width: width, height: RoleConfigs.Alert.actionHeight)
                
                addSubview(actionButton)
                lineY += RoleConfigs.Alert.actionHeight + 1
            }
        }
        
        let totalHeight = lineY
        layer.cornerRadius = 3
        clipsToBounds = true

        frame = CGRect(x: 0, y: 0, width: width, height: totalHeight)
    }
    
    @objc func performAction(at indext: Int) {
        if let action = actions.sy_Element(at: indext) {
            action._handler?(action)
        }
    }
}
