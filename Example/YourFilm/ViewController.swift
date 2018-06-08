//
//  ViewController.swift
//  YourFilm
//
//  Created by laichunhui on 02/07/2018.
//  Copyright (c) 2018 laichunhui. All rights reserved.
//

import UIKit
import YourFilm

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let alertView = AlertView.init(title: "lsjof", message: "k都弄得佛带动偶发方法", preferredStyle: .alert)
        let action = AlertAction.init(title: "k南方付款") { _ in
            print("ddfdfdfdfgg")
            YourFilm.curtainCall()
        }
        
        alertView.addAction(action)
        
        YourFilm.show(alertView)
        
        //YourFilm.showActivityIndicator(inView: view)
    }
}

