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
    _ character: ActorType,
    plot: Plot = .default,
    scenery: Scenery = .default,
    onView view: UIView? = nil
    )
    -> Film
{
    return Director.default.make(
        character,
        plot: plot,
        scenery: scenery,
        onView: view
    )
}
@discardableResult
public func pin(
    _ character: ActorType,
    scenery: Scenery = .default,
    onView view: UIView? = nil
    )
    -> Film
{
    var plot = Plot.default
    plot.showTimeDuration = TimeInterval(Int.max)
    return Director.default.make(
        character,
        plot: plot,
        scenery: scenery,
        onView: view
    )
}

@discardableResult
public func flash(
    _ character: ActorType,
    scenery: Scenery = .default,
    onView view: UIView? = nil
    )
    -> Film
{
    var plot = Plot.default
    plot.showTimeDuration = TimeInterval(Int.max)
    return Director.default.make(
        character,
        plot: plot,
        scenery: scenery,
        onView: view
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
        onView: nil
    )
}


@discardableResult
public func showActivityIndicator(inView view: UIView? = nil
    )
    -> Film
{
    let character = HUD(content: .activityIndicator)
    var plot = Plot.default
    plot.showTimeDuration = 15
    var scenery: Scenery = .default
    scenery.stageEffect = .dim
    
    return Director.default.make(
        character,
        plot: plot,
        scenery: scenery,
        onView: view
    )
}

public func curtainCall() {
    Director.default.currentFilm?.curtainCall()
}


