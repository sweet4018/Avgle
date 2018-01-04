//
//  String+URL.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/4.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import Foundation

extension String {
    
    ///將原始的url編碼為合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
}
