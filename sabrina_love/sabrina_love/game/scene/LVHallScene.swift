//
//  LVHallScene.swift
//  sabrina_love
//
//  Created by Jumbo on 2020/1/28.
//  Copyright © 2020 Jumbo. All rights reserved.
//

import SpriteKit

class LVHallScene: SKScene {
    
    private var lvPlayNode : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        // playNode Bounce
        self.lvPlayNode = self.childNode(withName: "lv_play") as? SKSpriteNode
        let scaleUp =  SKAction.scale(to: 1, duration: 0.75)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 1.2, duration: 0.75)
        scaleDown.timingMode = .easeInEaseOut
        
        let repeatAction = SKAction.sequence([scaleUp,scaleDown])
        lvPlayNode?.run(SKAction.repeatForever(repeatAction))

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            if (lvPlayNode?.contains(touchLocation))! {
                print("开始游戏！")
            }
        }
    }
    
}
