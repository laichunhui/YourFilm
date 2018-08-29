//
//  HUDExhibitionViewController.swift
//  YourFilm_Example
//
//  Created by mac on 2018/8/24.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

class HUDExhibitionViewController: UIViewController {
    let controlPanel = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    var faceEffectControl = UIView().then {
        $0.backgroundColor = UIColor(white: 0.8, alpha: 0.4)
        let label = UILabel().then {
            $0.text = "face effect"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.frame = CGRect(x: 15, y: 10, width: 70, height: 30)
        }
        $0.addSubview(label)
    }
    
    var stageEffectControl = UIView().then {
        $0.backgroundColor = UIColor(white: 0.8, alpha: 0.4)
        let label = UILabel().then {
            $0.text = "stage effect"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.frame = CGRect(x: 15, y: 10, width: 80, height: 30)
        }
        $0.addSubview(label)
    }
    
    var faceBgColorSelector: RGBColorSelector!
    var stageBgColorSelector: RGBColorSelector!
    
    let showButton = UIButton().then {
        $0.setTitle("showHUD", for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.backgroundColor = UIColor.blue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraint()
    }
    
    func setupUI() {
        view.addSubview(controlPanel)
        controlPanel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        controlPanel.addSubview(faceEffectControl)
        controlPanel.addSubview(stageEffectControl)
        
        faceBgColorSelector = RGBColorSelector.nibDefault
        faceEffectControl.addSubview(faceBgColorSelector)
        
        stageBgColorSelector = RGBColorSelector.nibDefault
        stageEffectControl.addSubview(stageBgColorSelector)
        
        showButton.addTarget(self, action: #selector(showHUD), for: .touchUpInside)
        controlPanel.addSubview(showButton)
    }
    
    func setupConstraint() {
        controlPanel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        faceEffectControl.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.size.equalTo(CGSize(width: view.frame.width, height: 380))
        }
        
        
        faceBgColorSelector.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.right.bottom.equalToSuperview()
            make.width.equalTo(260)
        }
        
        stageEffectControl.snp.makeConstraints { (make) in
            make.top.equalTo(faceEffectControl.snp.bottom)
            make.left.right.equalToSuperview()
            make.size.equalTo(CGSize(width: view.frame.width, height: 380))
        }
        
        stageBgColorSelector.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.right.bottom.equalToSuperview()
            make.width.equalTo(260)
        }
        
        showButton.snp.makeConstraints { (make) in
            make.top.equalTo(stageEffectControl.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 100, height: 50))
            make.bottom.equalTo(-50)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func showHUD() {
        let character = HUD.init(content: HUDContent.label("的您日涅i单独的覅哦哦"))
        
        var scenery = Scenery()
        scenery.spaceEffect = .color(faceBgColorSelector.color)
     //   scenery.stageEffect = .color(stageBgColorSelector.color)
        
        scenery.stageEffect = .dim
        YourFilm_Example.show(character, scenery: scenery, onView: view)
    }
}
