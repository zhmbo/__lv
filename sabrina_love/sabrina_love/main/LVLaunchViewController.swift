//
//  LVLaunchViewController.swift
//  sabrina_love
//
//  Created by Jumbo on 2020/1/15.
//  Copyright © 2020 Jumbo. All rights reserved.
//

import UIKit

class LVLaunchViewController: UIViewController {
    
    lazy var lvLoadingView: UILabel = {
        let lvLoadingView: UILabel = UILabel.init(frame: CGRect(x: 0, y: lvScreenHeight()-50, width: lvScreenWidth()-10, height: 40))
        lvLoadingView.text = "loading..."
        lvLoadingView.textColor = UIColor.white
        lvLoadingView.font = UIFont.systemFont(ofSize: 17)
        lvLoadingView.textAlignment = .right
        return lvLoadingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        if #available(iOS 13.0, *) {
            self.view.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(lvSabrinaInitFinish), name: lvNTFCSabrinaInitFinish, object: nil)
        
        self.view.addSubview(self.lvLoadingView)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func lvSabrinaInitFinish() {
        let lvRootVC: UIViewController!
        if lvInitModel.lvSuperScene {
            let superVC: LVBaseWKViewController = LVBaseWKViewController()
            superVC.wkRouter = lvInitModel.lv_supper_url
            lvRootVC = superVC
        }else {
            lvRootVC = LVGameViewController()
        }
        UIApplication.shared.keyWindow?.rootViewController = lvRootVC
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.lvLoadingView.frame = CGRect(x: 0, y: lvScreenHeight()-45, width: lvScreenWidth()-20, height: 40)
    }
    
}

