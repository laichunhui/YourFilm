//
//  Film.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/23.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

public protocol FilmDelegate: AnyObject {
    func filmDidStart(_ film: Film)
    func filmDidEnd(_ film: Film)
}

open class Film: NSObject {
    
    public weak var delegate: FilmDelegate?
    
    fileprivate var endTimer: Timer?
        
    // MARK: Properties
    open var character: Actor
    
    open var plot: Plot
   
    open var scenery: Scenery
    
    let space: Space
    
    public var view: UIView {
        return space
    }
    
    let identifier = NSUUID().uuidString
    
    public init(character: Actor, plot: Plot, scenery: Scenery) {
       
        self.character = character
        self.plot = plot
        self.scenery = scenery
        self.space = Space(plot: plot, effect: scenery.spaceEffect)
        
        super.init()
        if plot.willCurtainWhenTapSpace {
            let tap = UITapGestureRecognizer(target: self, action: #selector(curtainCall))
            self.space.addGestureRecognizer(tap)
        }
    }
    
    open func opening() {
        space.stage.display(character, effect: scenery.stageEffect)
        delegate?.filmDidStart(self)
    
        space.layer.add(Animation.opacityShow, forKey: "opacityAniamtion")
        if let appearAnim = plot.appearAnimation {
            space.stage.layer.add(appearAnim, forKey: "appearAnimation")
        }
        if let rolePlayAnimation = plot.rolePlayAnimation {
            character.animationLayer?.add(rolePlayAnimation, forKey: "rolePlayAnimation")
        }
        
        let timeinterval = plot.showTimeDuration - (plot.disappearAnimation?.duration ?? 0)
        endTimer?.invalidate()
        endTimer = Timer.scheduledTimer(timeInterval: timeinterval, target: self, selector: #selector(Film.curtainCall), userInfo: nil, repeats: false)
    }
    
    @objc open func curtainCall() {
        space.layer.add(Animation.opacityHidden, forKey: "opacityAniamtion")
        if let disappearAnim = plot.disappearAnimation {
            disappearAnim.delegate = self
            space.stage.layer.add(disappearAnim, forKey: "disappearAnimation")
        }
        else {
            space.clearUp()
            delegate?.filmDidEnd(self)
        }
    }
}

extension Film: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        endTimer?.invalidate()
        endTimer = nil
        plot.disappearAnimation?.delegate = nil
        plot.disappearAnimation = nil
        space.layer.removeAllAnimations()
        space.stage.layer.removeAllAnimations()
        character.animationLayer?.removeAllAnimations()
        space.clearUp()
        delegate?.filmDidEnd(self)
    }
}
