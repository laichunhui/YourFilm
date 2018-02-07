//
//  Film.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/23.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

public protocol FilmDelegate: class {
    func filmDidStart(_ film: Film)
    func filmDidEnd(_ film: Film)
}

open class Film: NSObject {
    
    weak var delegate: FilmDelegate?
    
    fileprivate var endTimer: Timer?
        
    // MARK: Properties
    open var character: RoleplayAble
    
    open var plot: Plot
   
    open var scenery: Scenery
    
    let space = Space()
    
    public init(character: RoleplayAble, plot: Plot, scenery: Scenery) {
        
        self.character = character
        self.plot = plot
        self.scenery = scenery
    }
    
    open func opening() {
        
        space.stage.position = plot.stagePisition
        space.stage.display(character)
        delegate?.filmDidStart(self)
        
        if let appearAnim = plot.appearAnimation {
            space.stage.layer.add(appearAnim, forKey: "appearAnimation")
        }
        
        let timeinterval =  plot.showTimeDuration - (plot.disappearAnimation?.duration ?? 0)
        endTimer?.invalidate()
        endTimer = Timer.scheduledTimer(timeInterval: timeinterval, target: self, selector: #selector(Film.curtainCall), userInfo: nil, repeats: false)
    }
    
    @objc open func curtainCall() {
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
        space.clearUp()
        delegate?.filmDidEnd(self)
    }
}
