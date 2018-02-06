//
//  Stage.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/22.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import Foundation

/** 
    舞台：提供给各类演员的表演空间
 */

public protocol StageAble {
    func display(withCharacter character: Character, backgroundView: UIView)
}

class Stage: UIVisualEffectView {
    
    internal init() {
        super.init(effect: UIBlurEffect(style: .light))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        backgroundColor = UIColor(white: 0.8, alpha: 0.36)
        layer.cornerRadius = 9.0
        layer.masksToBounds = true
        
        //contentView.addSubview(self.content)
        
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
    
    public func display(_ character: RoleplayAble) {
        //clearContents()
        self.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        frame.size = character.face.bounds.size
        contentView.addSubview(character.face)
    }
    
}

