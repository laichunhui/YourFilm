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
    public var showTimeDuration: TimeInterval = 2.0
    /// appearAnimation 和 disappearAnimation 动画对象为 stage
    public var appearAnimation: CAAnimation?
    public var disappearAnimation: CAAnimation?
    /// rolePlayAnimation 动画对象为 actor
    public var rolePlayAnimation: CAAnimation?
    
    public var stagePisition: StagePosition = .center
    
    public static let `default`: Plot = {
        var plot = Plot()
        plot.showTimeDuration = 2.0
        
        let appear = CATransition()
        appear.type = CATransitionType.reveal
        appear.duration = 0.2
        plot.appearAnimation = appear
        
        let disappear = CATransition()
        disappear.duration = 0.1
        disappear.type = CATransitionType.fade
        plot.disappearAnimation = disappear
        
        return plot
    }()
    
    func action() {
        
    }
    
    func stop() {
        
    }
}
