//
//  Scenery.swift
//  YourFilm
//
//  Created by chunhuiLai on 2016/12/27.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import Foundation

public enum StageEffectStyle {
    case clean
    case dim
}

public enum SpaceEffectStyle {
    case clean
    case dim
    case color(_: UIColor)
    case photoFrame(image: UIImage)
}

/** 布景 */
public class Scenery {

    public var spaceEffect: SpaceEffectStyle = .color(UIColor(white: 0, alpha: 0.6))
    
    //    init(mask: MaskType) {
    //        self.mask = mask
    //    }
    
    public static let `default`: Scenery = {
        let scenery = Scenery()
        scenery.spaceEffect = .dim
        return scenery
    }()
}
