//
//  LVBaseViewController.swift
//  sabrina_love
//
//  Created by Jumbo on 2020/1/24.
//  Copyright © 2020 Jumbo. All rights reserved.
//

import UIKit

class LVBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.view.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    // MARK: - 横竖屏管理
    override var prefersStatusBarHidden: Bool {
       return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
       return .default
    }

    override var shouldAutorotate: Bool {
       return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

}
