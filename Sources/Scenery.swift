//
//  Scenery.swift
//  YourFilm
//
//  Created by chunhuiLai on 2016/12/27.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

public enum StageEffectStyle {
    case blur
    case dim
    case color(_: UIColor)
}

public enum SpaceEffectStyle {
    case clean
    case dim
    case color(_: UIColor)
    case photoFrame(image: UIImage)
}

/** 布景 */
public struct Scenery {

    public var spaceEffect: SpaceEffectStyle = .clean
    
    public var stageEffect: StageEffectStyle = .blur

    init(spaceEffect: SpaceEffectStyle = .clean, stageEffect: StageEffectStyle = .blur) {
        self.spaceEffect = spaceEffect
        self.stageEffect = stageEffect
    }
    
    public static let `default`: Scenery = {
        let scenery = Scenery()
        return scenery
    }()
}
