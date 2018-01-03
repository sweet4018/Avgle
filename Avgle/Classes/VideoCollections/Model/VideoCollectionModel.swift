//
//  VideoCollectionModel.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/12/2.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit

class VideoCollectionModel: NSObject {
    
    var id: String?
    var title: String?
    var keyword: String?
    var cover_url: String?
    var total_views: String?
    var video_count: String?
    var collection_url: String?
    
    init(dict: [String: Any]) {
        
        id = dict["id"] as? String ?? ""
        title = dict["title"] as? String ?? ""
        keyword = dict["keyword"] as? String ?? ""
        cover_url = dict["cover_url"] as? String ?? ""
        total_views = dict["total_views"] as? String ?? ""
        video_count = dict["video_count"] as? String ?? ""
        collection_url = dict["collection_url"] as? String ?? ""
    }

}
