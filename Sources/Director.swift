//
//  Director.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/22.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

open class Director {
    static let `default` = Director()
    
    var currentFilm: Film?
    
    @discardableResult
    open func make(
        _ character: Actor,
        plot: Plot = .default,
        scenery: Scenery = .default,
        onView view: UIView? = nil) -> Film {
        /// 同一类别演员不能重复出现
        if let film = currentFilm, film.character.classify == character.classify {
            clean(film)
        }
        
        let film = Film(character: character, plot: plot, scenery: scenery)
        currentFilm = film
       
        if let view: UIView = view ?? UIApplication.shared.keyWindow {
            film.space.frame = view.bounds
            view.addSubview(film.space)
            film.opening()
        }
        return film
    }
    
    private func clean(_ film: Film) {
        film.space.clearUp()
        currentFilm = nil
    }
}
