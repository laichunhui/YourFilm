//
//  Stage.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/22.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

/** 
    舞台：提供给各类角色的展示空间
 */

public protocol StageAble {
    func display(withCharacter character: Character, backgroundView: UIView)
}

class Stage: UIVisualEffectView {
    var character: Actor?
    
    internal init() {
        super.init(effect: UIBlurEffect(style: .light))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {

    }
    
    func display(_ character: Actor, effect: StageEffectStyle) {
        self.character = character
        self.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        switch effect {
        case .blur:
            contentView.backgroundColor = UIColor(white: 0.8, alpha: 0.36)
            self.alpha = 0.85
        case .color(let color):
            contentView.backgroundColor = color
        case .dim:
            contentView.backgroundColor = UIColor.black
            self.alpha = 0.7
        case .clean:
            self.effect = nil
            self.contentView.backgroundColor = .clear
        }
        contentView.addSubview(character.face)
        
        if character.showMotionEffect {
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
    }
    
    override func updateConstraints() {
        guard let character = self.character else {
            return
        }
        let width = character.face.frame.width
        let height = character.face.frame.height
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
        self.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        self.addConstraint(heightConstraint)
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

