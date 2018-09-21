//
//  ViewController.swift
//  YourFilm
//
//  Created by laichunhui on 02/07/2018.
//  Copyright (c) 2018 laichunhui. All rights reserved.
//

import UIKit
import SYKit

typealias MenuAction = (title: String, action: Selector)

class ViewController: UIViewController {
    
    var datasource: [MenuAction] {
        return [
            (title: "showHUD", action: #selector(ViewController.showHUD)),
            (title: "showAlert", action: #selector(ViewController.showAlert)),
            (title: "showLoading", action: #selector(ViewController.showLoading))
        ]
    }
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    
    func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func showHUD() {
        performSegue(withIdentifier: "showHud", sender: nil)
    }
    
    @objc func showLoading() {
        showActivityIndicator()
    }
    
    @objc func showAlert() {
        let alert = AlertView.init(title: "慢慢", message: "滚滚滚", preferredStyle: .actionSheet)

        alert.addTextField { (field) in
            field.placeholder = "请输入来来来"
            field.borderStyle = .roundedRect
        }
        
        alert.addTextField { (field) in
            field.placeholder = "请就哦啊额偶奇偶金"
            field.borderStyle = .roundedRect
        }
        
        let action = AlertAction.init(title: "确定", handler: { _ in
            print("\(alert.textFields?.first?.text ?? "")")
            
    
        })
        alert.addAction(action)
        
        let action1 = AlertAction.init(title: "取消", handler: { _ in
            print("cancel()")
            curtainCall()
        })
        
        alert.addAction(action1)
        
        let destructive = AlertAction.init(title: "destructive", handler: { _ in
            print("destructive")
        })

        alert.addAction(destructive)
        pin(alert)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let model = datasource.sy_Element(at: indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
            cell.textLabel?.text = model.title
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let model = datasource.sy_Element(at: indexPath.row) {
            
            perform(model.action)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


