//
//  VideosCollectionViewCell.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/4.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit

class VideosCollectionViewCell: UICollectionViewCell {

    // MARK: - Property
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var likeLb: UILabel!
    @IBOutlet weak var durationLb: UILabel!
    
    var video: VideoModel? {
        didSet {
         
            let url = video!.preview_url?.urlEncoded()
            backgroundImageView.sd_setImage(with: URL(string: url!), completed: nil)
            
            titleLb.text = video!.title
            likeLb.text = getLikeLabelValue(like: video!.likes!, dislikes: video!.dislikes!)
            durationLb.text = getDurationTime(duration: video!.duration!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getLikeLabelValue(like: Int, dislikes: Int) -> String {
        
        var value: String? = "0%"
        let totalLikes: Float = Float(like + dislikes)
        
        if totalLikes != 0 {
            
            value =  String(format:"%.0f",( Float(like) / totalLikes * 100)) + "%"
        }
        return value!
    }
    
    func getDurationTime(duration: Float) -> String {
        
        var value: String? = "00:00"
        
        if (duration > 0) {
            let min: Int = Int(duration) / 60
            let sec: Int = Int(duration) % 60
            
            value = String(format: "%02i:%02i",min,sec)
        }
        return value!
    }
    
    
}
