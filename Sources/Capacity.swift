//
//  Capacity.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/22.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

// the ability of role should have 各个角色所应有的能力

public enum RoleType: String {
    case hud
    case alert
    case sheet
    
    case custom
}


public protocol RoleplayAble {
    
    var type: RoleType { get }
    
    var face: UIView { get }
    
    /**
     Current progress value. (0.0 - 1.0)
     */
 //   var progress: Double { set get }
}

public protocol FilmProgressDelegate {
    
    func progressChanged(progress: Double, on: UIView)
}

extension UIView: RoleplayAble {

    public var type: RoleType {  return RoleType.custom }
    
    public var face: UIView { return self }
    
//    public var progress: Double {
//        get {
//            return self.progress
//        }
//        set(newVlue) {
//            self.progress = newVlue
//        }}
}

