//
//  Stage.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/22.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

/** 
    舞台：提供给各类演员的表演空间
 */

public protocol StageAble {
    func display(withCharacter character: Character, backgroundView: UIView)
}

class Stage: UIVisualEffectView {
    var position: StagePosition = .center
    
    internal init() {
        super.init(effect: UIBlurEffect(style: .light))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        layer.cornerRadius = 9.0
        layer.masksToBounds = true
       
        let offset = 20.0
        let motionEffectsX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        motionEffectsX.maximumRelativeValue = offset
        motionEffectsX.minimumRelativeValue = -offset
        
        let motionEffectsY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        motionEffectsY.maximumRelativeValue = offset
        motionEffectsY.minimumRelativeValue = -offset
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [motionEffectsX, motionEffectsY]
        
        addMotionEffect(group)
    }
    
    func display(_ character: RoleplayAble, effect: StageEffectStyle) {
        //clearContents()
        self.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        switch effect {
        case .blur:
            backgroundColor = UIColor(white: 0.8, alpha: 0.36)
        case .color(let color):
            backgroundColor = color
        case .dim:
             backgroundColor = UIColor(white: 0.1, alpha: 0.56)
        }
        
        frame.size = character.face.bounds.size
        contentView.addSubview(character.face)
    }
    
}

