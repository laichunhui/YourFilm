//
//  YourFilm.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/23.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

@discardableResult
public func show(
    _ character: RoleplayAble,
    plot: Plot = .default,
    scenery: Scenery = .default,
    inView view: UIView? = nil
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
public func showAlertView(_ alert: AlertView)
    -> Film
{
    let character = alert
    var plot = Plot.default
    plot.showTimeDuration = TimeInterval(Int.max)
    switch alert.preferredStyle {
    case .actionSheet:
        plot.stagePisition = .bottom
    default:
        plot.stagePisition = .center
    }
    
    let scenery: Scenery = .default
    
    return Director.default.make(
        character,
        plot: plot,
        scenery: scenery,
        inView: nil
    )
}


@discardableResult
public func showActivityIndicator(inView view: UIView? = nil
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


