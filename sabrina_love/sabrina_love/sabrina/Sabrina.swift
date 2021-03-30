//
//  sabrina.swift
//  sabrina_love
//
//  Created by Jumbo on 2020/1/15.
//  Copyright © 2020 Jumbo. All rights reserved.
//

import UIKit

let lvNTFCSabrinaInitFinish: NSNotification.Name = Notification.Name("lvNTFCSabrinaInitFinish")

class Sabrina: NSObject {
    
    static let shared: Sabrina = Sabrina.init()
    
    public func initSbrina() {
        LVAPIService.shared.lv_sabrinaServiceInit {
            NotificationCenter.default.post(name: lvNTFCSabrinaInitFinish, object: nil)
        }
    }
    
}
