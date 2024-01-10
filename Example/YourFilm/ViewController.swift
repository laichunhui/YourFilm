//
//  ViewController.swift
//  YourFilm
//
//  Created by laichunhui on 02/07/2018.
//  Copyright (c) 2018 laichunhui. All rights reserved.
//

import UIKit
import YourFilm

typealias MenuAction = (title: String, action: Selector)

class ViewController: UIViewController {
    
    var timer: Timer?
    
    var datasource: [MenuAction] {
        return [
            (title: "showHUD", action: #selector(ViewController.showHUD)),
            (title: "showAlert", action: #selector(ViewController.showAlert)),
            (title: "showSheet", action: #selector(ViewController.showSheet)),
            (title: "showActivity", action: #selector(ViewController.showActivity)),
            (title: "showLoading", action: #selector(ViewController.showLoading)),
            (title: "showProgress", action: #selector(ViewController.showProgress)),
            (title: "showCustomView", action: #selector(ViewController.showCustomView))
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
        YourFilm.cleanAllFilms()
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
        YourFilm.showLoading(image: image, title: "正在加载",scenery: scene, onView: self.view)
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
//        YourFilm.show(view, plot: plot)
        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (0.2 * Double(i))) {
                showActivityIndicator(onView: self.tableView)
            }
        }
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
        YourFilm.pin(actor, scenery: scene, onView: self.tableView)

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
        var config = AlertConfig.default
        config.titleFont = UIFont.boldSystemFont(ofSize: 18)
        config.textFont = UIFont.systemFont(ofSize: 16)
        let alert = Alert.init(title: "To see a world in a grain of sand",
                               message:
                                """
                                1. The ranking list is the ranking of cummulative golds consumption of all Gold games
                                2. The dayliy list is calculated based on the cumulative gold consumed in all Gold Games in the past 7 days.
                                3. The weekly list is calculated based on the cumulative gold consumption of all Gold Games in the past 7 days.
                                """,
                               config: config, theme: .white)
        let cancelBlock: (() -> Void) = {
            YourFilm.cleanFilms(with: .alert)
        }
        
        var action = AlertAction(title: "Confirm", handler: {
            cancelBlock()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15, execute: DispatchWorkItem.init(block: {
                let vc = UIViewController()
                vc.view.backgroundColor = .blue
                self.navigationController?.pushViewController(vc, animated: true)
            }))
        })
        action.titleColor = 0x5DCE7A.color
        action.font = UIFont.boldSystemFont(ofSize: 16)
        var action1 = AlertAction(title: "Cancel", handler: {
            print("cancel()")
            cancelBlock()
        })
        action1.titleColor = 0x111111.color.withAlphaComponent(0.5)
        action1.font = UIFont.systemFont(ofSize: 16)
        
        alert.setActions([action, action1])
        pin(alert, scenery: Scenery.init(spaceEffect: SpaceEffectStyle.color(UIColor.black.withAlphaComponent(0.5)), stageEffect: .clean), onView: nil)
    }
    
    @objc func showSheet() {
        let sheet = Sheet(theme: .white)
        let cancelBlock: (() -> Void) = {
            YourFilm.cleanFilms(with: .sheet)
        }
        var action = AlertAction(title: "举报", handler: {
            cancelBlock()
        })
        action.titleColor = UIColor(white: 1, alpha: 0.8)
        var action1 = AlertAction(title: "拉黑", handler: {
            cancelBlock()
        })
        action1.titleColor = UIColor(white: 1, alpha: 0.8)
        var cancelAction = AlertAction(title: "取消", handler: {
            cancelBlock()
        })
        cancelAction.titleColor = UIColor(white: 1, alpha: 0.8)
        cancelAction.font = UIFont.boldSystemFont(ofSize: 16)
        sheet.cancelAction = cancelAction
        sheet.setActions([action, action1])
        
        let scenery = Scenery.init(spaceEffect: SpaceEffectStyle.color(UIColor.black.withAlphaComponent(0.8)), stageEffect: .clean)
        var plot = Plot.default
        plot.stagePisition = .bottom
        
        let appear = CATransition()
        appear.duration = 0.25
        appear.type = CATransitionType.moveIn
        appear.subtype = .fromTop
        plot.appearAnimation = appear

        let disappear = CABasicAnimation()
        disappear.keyPath = "position.y"
        disappear.duration = 0.25
        disappear.toValue = UIScreen.main.bounds.size.height
        plot.disappearAnimation = disappear

        plot.showTimeDuration = TimeInterval(Int.max)
        YourFilm.show(sheet, plot: plot, scenery: scenery)
    }
    
    @objc func showCustomView() {
        let customView = CustomView()
        customView.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        customView.backgroundColor = .green
        var plot = Plot.default
        plot.isUserInteractionEnabled = false
        plot.showTimeDuration = 5.f
        YourFilm.show(customView, plot: plot, scenery: Scenery.init(spaceEffect: SpaceEffectStyle.color(UIColor.black.withAlphaComponent(0.5)), stageEffect: .clean))
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


class CustomView: UIView {
    deinit {
        print("CustomView deinit")
    }
}

class CustomView2: UIView {
 
}
