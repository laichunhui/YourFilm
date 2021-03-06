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
    
    var timer: Timer?
    
    var datasource: [MenuAction] {
        return [
            (title: "showHUD", action: #selector(ViewController.showHUD)),
            (title: "showAlert", action: #selector(ViewController.showAlert)),
            (title: "showActivity", action: #selector(ViewController.showActivity)),
            (title: "showLoading", action: #selector(ViewController.showLoading)),
            (title: "showProgress", action: #selector(ViewController.showProgress))
        ]
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = 0x3B3B3B.color
        tableView.separatorStyle = .none

        return tableView
    }()
    
    let rightItem = UIButton().then {
        $0.setTitle("clean", for: .normal)
    }
    
    @objc func cleanAll() {
        YourFilm_Example.cleanAllFilms()
    }
    
    func setupUI() {
        self.title = "YourFilm"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItem)
        rightItem.addTarget(self, action: #selector(ViewController.cleanAll), for: .touchUpInside)

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let tap = UISwipeGestureRecognizer(target: self, action: #selector(showActivity))
        self.view.addGestureRecognizer(tap)
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
        var scene = Scenery.default
        scene.stageEffect = .color(.white)
        scene.spaceEffect = .color(UIColor.black.withAlphaComponent(0.5))
        YourFilm_Example.showLoading(image: image, title: "正在加载",scenery: scene, onView: self.view)
    }
    
    @objc func showActivity() {
//        let view = UIView().then {
//            $0.backgroundColor = .green
//        }
//        view.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
//        var plot = Plot.default
//        plot.showTimeDuration = TimeInterval(Int.max)
//        plot.stagePisition = .top
//        plot.stageContentOffset = CGPoint(x: -15, y: 200)
//        YourFilm_Example.show(view, plot: plot)
        showActivityIndicator(onView: self.tableView)
    }
    
    @objc func showProgress() {
        var progress = 0.f
        
        let veil = ProgressRingVeil()
        veil.maxValue = 1
        veil.innerRingColor = 0x3377FF.color
        veil.outerRingColor = 0x999999.color
        
        let actor = HUD(content: HUDContent.progress(veil: veil))
        var scene = Scenery.default
        scene.stageEffect = .color(.white)
        scene.spaceEffect = .color(UIColor.black.withAlphaComponent(0.5))
        YourFilm_Example.pin(actor, scenery: scene, onView: self.tableView)

        if #available(iOS 10.0, *) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (_) in

                progress += 0.05
                veil.startProgress(to: progress, duration: 0.1)
             
                if progress > 1 {
                    self?.timer?.invalidate()
                    self?.timer = nil
                }
            })

        } else {

        }
    }
    
    @objc func showAlert() {
        //The beer foamed up and overflowed the glass
        let alert = AlertView.init(title: "伤痛千万次", message: "那就这样吧，别离便去吧。发发呆反弹规范化发过火发给回复听光辉天誉花园 和太阳花一体化拖后腿好讨厌。", preferredStyle: .actionSheet, theme: .white)

//        alert.addTextField { (field) in
//            field.placeholder = "请输入"
//            field.borderStyle = .roundedRect
//            field.font = UIFont.systemFont(ofSize: 14)
//        }

        let action = AlertAction(title: "确认", handler: { action in
            
//            print("\(alert.textFields?.first?.text ?? "")")
        })
        alert.addAction(action)
        var cancelBlock: (() -> Void)?
        let action1 = AlertAction(title: "取消", handler: { _ in
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
            
            switch model.title {
            case "showActivity", "showLoading":
                cell.accessoryType = .none
            default:
                cell.accessoryType = .disclosureIndicator
            }

            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let model = datasource.yf_Element(at: indexPath.row) {
            
            perform(model.action)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


