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
    plot.willCurtainWhenTapSpace = false
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
    font: UIFont? = nil,
    onView view: UIView? = nil
    )
    -> Film
{
    let character = HUD.init(content: HUDContent.label(text, textColor: textColor, font: font))
    var scenery = Scenery()
    scenery.spaceEffect = .clean
    scenery.stageEffect = .dim
    var plot = Plot.default
    plot.showTimeDuration = 2
    plot.willCurtainWhenTapSpace = false
    
    return Director.default.make(
        character,
        plot: plot,
        scenery: scenery,
        onView: view
    )
}

@discardableResult
public func showAlertView(_ alert: Alert)
    -> Film
{
    let character = alert
    var plot = Plot.default
    plot.showTimeDuration = TimeInterval(Int.max)
    plot.stagePisition = .center
    
    plot.willCurtainWhenTapSpace = false
    
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
    plot.willCurtainWhenTapSpace = false
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
public func showLoading(image: UIImage, title: String?, scenery: Scenery = .default, onView view: UIView? = nil
    )
    -> Film
{
    let character = HUD(content: .loading(image: image, title: title))
    var plot = Plot.default
    plot.showTimeDuration = 12
    plot.willCurtainWhenTapSpace = false
    plot.rolePlayAnimation = Animation.continuousRotation
    
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

public func cleanFilms(with actorClassify: ActorClassify, in view: UIView? = nil) {
    Director.default.cleanFilms(with: actorClassify, in: view)
}


