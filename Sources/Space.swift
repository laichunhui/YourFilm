//
//  ProjectionRoom.swift
//  YourFilm
//
//  Created by chunhuiLai on 2016/12/28.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

public class ProjectionRoom {
    
}

class Space: UIView {
    
    var stage: Stage
    var effect: SpaceEffectStyle
    
    init(stage: Stage = Stage(), effect: SpaceEffectStyle) {
        self.stage = stage
        self.effect = effect
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.stage = Stage()
        self.effect = .clean
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate let backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate func commonInit() {
        switch effect {
        case .dim:
            backgroundView.backgroundColor = UIColor(white:0.0, alpha:0.25)
        case .color(let color):
            backgroundView.backgroundColor = color
        default:
            backgroundColor = UIColor.clear
        }
        
        addSubview(backgroundView)
        addSubview(stage)
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        switch stage.position {
        case .bottom:
            stage.center.x = center.x
            stage.center.y = UIScreen.main.bounds.size.height - stage.frame.height / 2 - 10
        default:
            stage.center = center
        }
        
        backgroundView.frame = bounds
    }

    func clearUp() {
        removeFromSuperview()
    }
}
