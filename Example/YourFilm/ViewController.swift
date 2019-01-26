//
//  ViewController.swift
//  YourFilm
//
//  Created by laichunhui on 02/07/2018.
//  Copyright (c) 2018 laichunhui. All rights reserved.
//

import UIKit


typealias MenuAction = (title: String, action: Selector)

class ViewController: UIViewController {
    
    var datasource: [MenuAction] {
        return [
            (title: "showHUD", action: #selector(ViewController.showHUD)),
            (title: "showAlert", action: #selector(ViewController.showAlert)),
            (title: "showActivity", action: #selector(ViewController.showActivity)),
            (title: "showLoading", action: #selector(ViewController.showLoading))
        ]
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(yfHexValue: 0x3B3B3B)
        tableView.separatorStyle = .none

        return tableView
    }()
    
    let rightItem = UIButton().then {
        $0.setTitle("clean", for: .normal)
    }
    
    @objc func cleanAll() {
        YourFilm_Example.curtainCallAll()
    }
    
    func setupUI() {
        self.title = "YourFilm"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItem)
        rightItem.addTarget(self, action: #selector(ViewController.cleanAll), for: .touchUpInside)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.1, green:0.1, blue:0.1, alpha:1)
    }
    
    @objc func showHUD() {
        performSegue(withIdentifier: "showHud", sender: nil)
    }
    
    @objc func showLoading() {
        let image = UIImage(named: "com_loading_red")!
        YourFilm_Example.showLoading(image: image, title: "正在加载", onView: self.tableView)
    }
    
    @objc func showActivity() {
        showActivityIndicator()
    }
    
    @objc func showAlert() {
        let alert = AlertView.init(title: "玻璃杯", message: "The beer foamed up and overflowed the glass", preferredStyle: .actionSheet)

        alert.addTextField { (field) in
            field.placeholder = "请输入啦啦啦"
            field.borderStyle = .roundedRect
        }
        
        let action = AlertAction.init(title: "确定", handler: { _ in
            print("\(alert.textFields?.first?.text ?? "")")
        })
        alert.addAction(action)
        var cancelBlock: (() -> Void)?
        let action1 = AlertAction.init(title: "取消", handler: { _ in
            print("cancel()")
            cancelBlock?()
        })
        
        alert.addAction(action1)
        let film = pin(alert)
        cancelBlock = { film.curtainCall() }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let model = datasource.yf_Element(at: indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
            cell.textLabel?.text = model.title
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let model = datasource.yf_Element(at: indexPath.row) {
            
            perform(model.action)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


