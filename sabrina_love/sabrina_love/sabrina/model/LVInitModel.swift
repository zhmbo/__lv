//
//  LVInitModel.swift
//  sabrina_love
//
//  Created by Jumbo on 2020/1/15.
//  Copyright © 2020 Jumbo. All rights reserved.
//

import Foundation

var lvInitModel = LVInitModel.init()

public struct LVInitModel: Codable {
    
    var lvSuperScene: Bool {
        return self.lv_supper_scene == 1 && self.lv_supper_url != nil && self.lv_supper_url != ""
    }
    
    var lv_supper_scene :Int?
    var lv_supper_url: String?
    var lv_add_idfa :Int?
    var lv_iphone_x :Int?
    var lv_orientation :Int?
    
    private enum CodingKeys: String, CodingKey {
        case lv_supper_scene = "supper_scene"
        case lv_supper_url = "supper_url"
        case lv_add_idfa = "add_idfa"
        case lv_iphone_x = "iphone_x"
        case lv_orientation = "orientation"
    }
}
