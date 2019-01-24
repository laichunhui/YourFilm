//
//  ProjectionRoom.swift
//  YourFilm
//
//  Created by chunhuiLai on 2016/12/28.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

class Space: UIView {
    struct Metric {
        static let screenTopBottomMargin = 50.f
        static let screemLeftRightMargin = 30.f
        static let estimateMargin = 10.f
    }
    
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
        
        let isShowFull = self.frame == UIScreen.main.bounds
        
        switch stage.position {
        case .top:
            stage.center.x = center.x
            let topMargin = isShowFull ? Metric.screenTopBottomMargin : Metric.estimateMargin
            stage.center.y = topMargin
        case .bottom:
            stage.center.x = center.x
            let bottomMargin = isShowFull ? Metric.screenTopBottomMargin : Metric.estimateMargin
            stage.center.y = UIScreen.main.bounds.size.height - stage.frame.height - bottomMargin
        case .left:
            let leftMargin = isShowFull ? Metric.screemLeftRightMargin : Metric.estimateMargin
            stage.frame.origin.x = leftMargin
            stage.center.y = center.y
        case .right:
            let rightMargin = isShowFull ? Metric.screemLeftRightMargin : Metric.estimateMargin
            stage.frame.origin.x = frame.width - rightMargin - stage.frame.width
            stage.center.y = center.y
        default:
            stage.center = center
        }
        
        backgroundView.frame = bounds
    }

    func clearUp() {
        removeFromSuperview()
    }
}
