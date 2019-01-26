//
//  Director.swift
//  YourFilm
//
//  Created by ChunhuiLai on 2016/12/22.
//  Copyright © 2016年 qjzh. All rights reserved.
//

import UIKit

open class Director {
    public static let `default` = Director()
    
    var currentFilm: Film?
    var films: [Film] = []
    
    @discardableResult
    open func make(
        _ character: Actor,
        plot: Plot = .default,
        scenery: Scenery = .default,
        onView view: UIView? = nil) -> Film {
 
        let newfilm = Film(character: character, plot: plot, scenery: scenery)
        newfilm.delegate = self
        currentFilm = newfilm
        films.append(newfilm)
        
        if let view: UIView = view ?? UIApplication.shared.keyWindow {
            newfilm.space.frame = view.bounds
            view.addSubview(newfilm.space)
            newfilm.opening()
        }
        return newfilm
    }
    
    public func cleanLastFilm() {
        currentFilm?.curtainCall()
    }
    
    public func cleanFilms(with actorClassify: ActorClassify) {
        films.filter { $0.character.classify == actorClassify  }
            .forEach { (film) in
                film.curtainCall()
        }
    }
    
    public func cleanAllFilms() {
        films.forEach { film in
            film.curtainCall()
        }
    }
}

extension Director: FilmDelegate {
    public func filmDidStart(_ film: Film) {
        
    }
    
    public func filmDidEnd(_ film: Film) {
        films = films.filter { $0.identifier != film.identifier }
        currentFilm = films.last
    }
}
