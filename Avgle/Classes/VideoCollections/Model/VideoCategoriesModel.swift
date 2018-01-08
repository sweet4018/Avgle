//
//  VideoCategoriesModel.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/11/25.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit

class VideoCategoriesModel: NSObject {

    var CHID: String?
    var name: String?
    var slug: String?
    var total_videos: Int?
    var category_url: String?
    var cover_url: String?
    
    init(dict: [String: Any]) {
        
        CHID = dict["CHID"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        slug = dict["slug"] as? String ?? ""
        total_videos = dict["total_videos"] as? Int ?? 0
        category_url = dict["category_url"] as? String ?? ""
        cover_url = dict["cover_url"] as? String ?? ""        
    }
}
