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
        static let estimateMargin = 15.f
    }
    
    var plot: Plot
    var stage: Stage
    var effect: SpaceEffectStyle
    
    init(stage: Stage = Stage(), plot: Plot, effect: SpaceEffectStyle) {
        self.stage = stage
        self.plot = plot
        self.effect = effect
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func clearUp() {
        removeFromSuperview()
    }
    
    override func updateConstraints() {
        let isShowFull = self.frame == UIScreen.main.bounds
        var top = isShowFull ? Metric.estimateMargin : 0
        top += plot.stageContentOffset.y
        if #available(iOS 11.0, *) {
            top += self.safeAreaInsets.top
        }
        
        var bottom = isShowFull ? -Metric.estimateMargin : 0
        bottom += plot.stageContentOffset.y
        if #available(iOS 11.0, *) {
            bottom -= self.safeAreaInsets.bottom
        }
        
        stage.translatesAutoresizingMaskIntoConstraints = false
        switch plot.stagePisition {
        case .top:
            NSLayoutConstraint.activate([
                stage.topAnchor.constraint(equalTo: self.topAnchor, constant: top),
                stage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: plot.stageContentOffset.x)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                stage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottom),
                stage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: plot.stageContentOffset.x)
            ])
        case .left:
            let left = isShowFull ? Metric.estimateMargin : 0
            NSLayoutConstraint.activate([
                stage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: plot.stageContentOffset.y),
                stage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: left + plot.stageContentOffset.x)
            ])
        case .right:
            let right = isShowFull ? -Metric.estimateMargin : 0
            NSLayoutConstraint.activate([
                stage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: plot.stageContentOffset.y),
                stage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: right + plot.stageContentOffset.x)
            ])
        default:
            NSLayoutConstraint.activate([
                stage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: plot.stageContentOffset.y),
                stage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: plot.stageContentOffset.x),
            ])
        }
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
            backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.0),
            backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0.0),
        ])
        
        super.updateConstraints()
    }
}
