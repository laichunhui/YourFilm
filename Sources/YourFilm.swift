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
    _ character: Actor,
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
    _ character: Actor,
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
public func showText(
    _ text: String,
    textColor: UIColor = .white,
    onView view: UIView? = nil
    )
    -> Film
{
    let character = HUD.init(content: HUDContent.label(text, textColor: textColor))
    var scenery = Scenery()
    scenery.spaceEffect = .clean
    scenery.stageEffect = .dim
    var plot = Plot.default
    plot.showTimeDuration = 2
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
public func showActivityIndicator(onView view: UIView? = nil
    )
    -> Film
{
    let character = HUD(content: .activityIndicator)
    var plot = Plot.default
    plot.showTimeDuration = 12
    var scenery: Scenery = .default
    scenery.stageEffect = .dim
    
    return Director.default.make(
        character,
        plot: plot,
        scenery: scenery,
        onView: view
    )
}

@discardableResult
public func showLoading(image: UIImage, title: String?, onView view: UIView? = nil
    )
    -> Film
{
    let character = HUD(content: .loading(image: image, title: title))
    var plot = Plot.default
    plot.showTimeDuration = 12
    plot.rolePlayAnimation = Animation.continuousRotation
    var scenery: Scenery = .default
    scenery.stageEffect = .clean
    
    return Director.default.make(
        character,
        plot: plot,
        scenery: scenery,
        onView: view
    )
}

/** 此处只能清除通过 director 创建的film */
public func cleanAllFilms() {
    Director.default.cleanAllFilms()
}


