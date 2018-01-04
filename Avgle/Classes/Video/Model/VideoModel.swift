//
//  VideoModel.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/4.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit

class VideoModel: NSObject {

    var vid: String?
    var uid: String?
    var title: String?
    var keyword: String?
    var channel: String?
    var duration: Float?
    var framerate: Int?
    var hd: Bool?
    var addtime: Int?
    var viewnumber: Int?
    var likes: Int?
    var dislikes: Int?
    var video_url: String?
    var embedded_url: String?
    var preview_url: String?
    var preview_video_url: String?
    
    init(dict: [String: Any]) {
        
        vid = dict["vid"] as? String ?? ""
        uid = dict["uid"] as? String ?? ""
        title = dict["title"] as? String ?? ""
        keyword = dict["keyword"] as? String ?? ""
        channel = dict["channel"] as? String ?? ""
        duration = dict["duration"] as? Float ?? 0.0
        framerate = dict["framerate"] as? Int ?? 0
        hd = dict["hd"] as? Bool ?? false
        addtime = dict["addtime"] as? Int ?? 0
        viewnumber = dict["viewnumber"] as? Int ?? 0
        likes = dict["likes"] as? Int ?? 0
        dislikes = dict["dislikes"] as? Int ?? 0
        video_url = dict["video_url"] as? String ?? ""
        embedded_url = dict["embedded_url"] as? String ?? ""
        preview_url = dict["preview_url"] as? String ?? ""
        preview_video_url = dict["preview_video_url"] as? String ?? ""
    }
    
}
