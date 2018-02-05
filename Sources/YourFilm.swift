//
//  YourFilm.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/23.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import Foundation

@discardableResult
public func show(
    _ character: RoleplayAble,
    plot: Plot = .default,
    scenery: Scenery = .default,
    inView view: UIView? = UIApplication.shared.keyWindow
    )
    -> Film
{
    return Director.default.make(
        character,
        plot: plot,
        scenery: scenery,
        inView: view
    )
}

@discardableResult
public func showActivityIndicator(inView view: UIView? = UIApplication.shared.keyWindow
    )
    -> Film
{
    let character = HUD(content: .activityIndicator)
    var plot = Plot.default
    plot.showTimeDuration = 10.0
    let scenery: Scenery = .default
    
    return Director.default.make(
        character,
        plot: plot,
        scenery: scenery,
        inView: view
    )
}

public func curtainCall() {
    Director.default.currentFilm?.curtainCall()
}


