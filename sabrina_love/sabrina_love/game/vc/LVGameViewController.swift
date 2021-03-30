//
//  LVGameViewController.swift
//  sabrina_love
//
//  Created by Jumbo on 2020/1/21.
//  Copyright © 2020 Jumbo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class LVGameViewController: LVBaseViewController {
    
    override func loadView() {
        self.view = SKView.init(frame: UIScreen.main.bounds)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .black
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'LVHallScene.sks'
            if let hallScene = SKScene(fileNamed: "LVHallScene") {
                // Set the scale mode to scale to fit the window
                hallScene.size = CGSize(width: 2436, height: 1125)
                hallScene.scaleMode = .aspectFill
                
                // Present the scene
                //交叉淡入淡出
                view.presentScene(hallScene, transition: .crossFade(withDuration: 0.5))
            }
            
//            view.ignoresSiblingOrder = true
//            #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
//            #endif
        }
    }
}
