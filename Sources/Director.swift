//
//  Director.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/22.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import Foundation

open class Director {
    static let `default` = Director()
    
    var currentFilm: Film?
    
    @discardableResult
    open func make(
        _ character: RoleplayAble,
        plot: Plot = .default,
        scenery: Scenery = .default,
        inView view: UIView? = UIApplication.shared.keyWindow) -> Film {
        
        if let film = currentFilm {
            clean(film)
        }
        
        let film = Film(character: character, plot: plot, scenery: scenery)
        currentFilm = film
       
        let view: UIView = view ?? UIApplication.shared.keyWindow!
                
        film.space.frame = view.bounds
        view.addSubview(film.space)
        film.opening()
        
        return film
    }
    
    private func clean(_ film: Film) {
        film.space.clearUp()
        currentFilm = nil
    }
    
}
