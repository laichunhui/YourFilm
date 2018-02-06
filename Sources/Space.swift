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
    
    init(stage: Stage = Stage()) {
        self.stage = stage
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        stage = Stage()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white:0.0, alpha:0.25)
        view.alpha = 0.0
        return view
    }()
    
    fileprivate func commonInit() {
        backgroundColor = UIColor.clear
        
        addSubview(backgroundView)
        addSubview(stage)
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        stage.center = center
        backgroundView.frame = bounds
    }

    func clearUp() {
        removeFromSuperview()
    }
}
