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
    
}

public protocol FilmProgressDelegate {
    
    func progressChanged(progress: Double, on: UIView)
}

extension UIView: RoleplayAble {

    public var type: RoleType {  return RoleType.custom }
    
    public var face: UIView { return self }
    
}
