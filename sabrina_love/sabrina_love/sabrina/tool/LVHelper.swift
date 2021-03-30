//
//  LVHelper.swift
//  sabrina_love
//
//  Created by Jumbo on 2020/1/19.
//  Copyright © 2020 Jumbo. All rights reserved.
//

import UIKit
import AdSupport

var lvScreenWidth = {
    return UIScreen.main.bounds.size.width
}
var lvScreenHeight = {
    return UIScreen.main.bounds.size.height
}

var isFullScreen: Bool {
    if #available(iOS 11, *) {
          guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
              return false
          }
          
          if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
//              print(unwrapedWindow.safeAreaInsets)
              return true
          }
    }
    return false
}

var lvIdfa: String {
    var idfa = LVKeyChain.keyChainReadData(identifier: "kcSabrinaIdfa")
    if (idfa as? String) == "" || (idfa as? String) == nil {
        idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            _ = LVKeyChain.keyChainSaveData(data: idfa, withIdentifier: "kcSabrinaIdfa")
        }
    }
    return idfa as! String
}
