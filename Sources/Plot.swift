//
//  Plot.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/23.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

enum FilmAnimation {
    case showTimeDuration(_ : TimeInterval)
    case appearAnimation(_ : CAAnimation)
    case disappearAnimation(_ : CAAnimation)
    
    var key: String? {
        switch self {
        case .appearAnimation:
            return "appearAnimation"
        case .disappearAnimation:
            return "disappearAnimation"
        default:
            return nil
        }
    }
}


public enum StagePosition {
    case center
    case bottom
}

public struct Plot {
    public var showTimeDuration: TimeInterval = 2.0
    public var appearAnimation: CAAnimation?
    public var disappearAnimation: CAAnimation?
    
    public var stagePisition: StagePosition = .center
    
    public static let `default`: Plot = {
        var plot = Plot()
        plot.showTimeDuration = 2.0
    
        let appear = CABasicAnimation(keyPath: "alpha")
        appear.fromValue = 0.0
        appear.toValue = 1.0
        appear.duration = 0.2
        
        plot.appearAnimation = appear
        
        let disappear = CABasicAnimation(keyPath: "alpha")
        disappear.fromValue = 1.0
        disappear.toValue = 0.0
        appear.duration = 0.2
        
        plot.disappearAnimation = disappear
        
        return plot
    }()
    
    func action() {
        
    }
    
    func stop() {
        
    }
}
