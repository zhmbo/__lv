//
//  LVSecurity.swift
//  sabrina_love
//
//  Created by Jumbo on 2020/1/15.
//  Copyright © 2020 Jumbo. All rights reserved.
//

import UIKit
import CommonCrypto

class LVSecurity: NSObject {
    
}

extension String {
    // base64编码
    func lv_toBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    // base64解码
    func lv_fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    // md5
    var lv_md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
}
