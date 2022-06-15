//
//  Plot.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/23.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

typealias FilmAction = (Bool) -> Void

enum FilmAnimation {
    case appearAnimation(_ : CAAnimation)
    case disappearAnimation(_ : CAAnimation)
    case progressAnimation(_ : CAAnimation)
    
    var key: String? {
        switch self {
        case .appearAnimation:
            return "appearAnimation"
        case .disappearAnimation:
            return "disappearAnimation"
        case .progressAnimation:
            return "progressAnimation"
        }
    }
}

public enum StagePosition {
    case center
    case top
    case left
    case right
    case bottom
}

public struct Plot {
    public var stageCornerRadius: CGFloat = 12
    public var showTimeDuration: TimeInterval = 2.0
    /// appearAnimation 和 disappearAnimation 动画对象为 stage
    public var appearAnimation: CAAnimation?
    public var disappearAnimation: CAAnimation?
    /// rolePlayAnimation 动画对象为 actor
    public var rolePlayAnimation: CAAnimation?
    /// 内容主体位置布局
    public var stagePisition: StagePosition = .center
    /// 内容主体偏移量
    public var stageContentOffset: CGPoint = CGPoint.zero
    /// true时点击背景内容消失
    public var willCurtainWhenTapSpace = true
    
    public static let `default`: Plot = {
        var plot = Plot()
        plot.showTimeDuration = 2.0
        
        let popAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        popAnimation.duration = 0.3
        popAnimation.values = [NSValue.init(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1.0)),
                               NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
                               NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
                               NSValue.init(caTransform3D: CATransform3DIdentity)]
        popAnimation.keyTimes = [NSNumber.init(value: 0.0),
                                 NSNumber.init(value: 0.5),
                                 NSNumber.init(value: 0.75),
                                 NSNumber.init(value: 1.0)]
        popAnimation.timingFunctions = [CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),
                                        CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),
                                        CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)]
        plot.appearAnimation = popAnimation
        
        
        let disappear = CAKeyframeAnimation.init(keyPath: "transform")
        disappear.duration = 0.25
        disappear.values = [NSValue.init(caTransform3D: CATransform3DIdentity),
                               NSValue.init(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0))]
        disappear.keyTimes = [NSNumber.init(value: 0.0), NSNumber.init(value: 1.0)]
        disappear.timingFunctions = [CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),
                                        CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)]
        disappear.fillMode = .forwards
        disappear.isRemovedOnCompletion = false
        plot.disappearAnimation = disappear
        
        return plot
    }()
    
    func action() {
        
    }
    
    func stop() {
        
    }
}
