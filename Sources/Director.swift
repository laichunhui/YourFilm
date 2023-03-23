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
    
    private init() {
        
    }
    
    @discardableResult
    open func make(
        _ character: Actor,
        plot: Plot = .default,
        scenery: Scenery = .default,
        onView view: UIView? = nil) -> Film {
        /// 如果是同类型内容, 在当前内容消失前不再创建新内容
        if let currentFilm = currentFilm, currentFilm.character.classify == character.classify {
            return currentFilm
        }
            
        let newfilm = Film(character: character, plot: plot, scenery: scenery)
        newfilm.delegate = self
        currentFilm = newfilm
        films.append(newfilm)
        
        if let view: UIView = view ?? UIApplication.shared.keyWindow {
            view.addSubview(newfilm.space)
            newfilm.space.frame = view.bounds
            
            newfilm.space.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newfilm.space.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
                newfilm.space.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0),
                newfilm.space.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0.0),
                newfilm.space.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0.0),
            ])
            newfilm.opening()
        }
        return newfilm
    }
    
    public func cleanLastFilm() {
        currentFilm?.curtainCall()
    }
    
    public func cleanFilms(with actorClassify: ActorClassify, in view: UIView? = nil) {
        films.filter { $0.character.classify == actorClassify  }
            .forEach { (film) in
                if let view = view, film.space.superview === view {
                    film.curtainCall()
                }
                else {
                    film.curtainCall()
                }
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
