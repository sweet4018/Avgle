//
//  VideoCategoriesCollectionViewCell.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/2.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import SDWebImage

class VideoCategoriesCollectionViewCell: UICollectionViewCell {

    //MARK: - Property
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var deputyLb: UILabel!
    
    
    
    var videoCategories: VideoCategoriesModel? {
        didSet {
            
            let url = videoCategories!.cover_url
            backgroundImageView.sd_setImage(with: URL(string: url!), completed: nil)
            
            titleLb.text = videoCategories!.name
            deputyLb.text = NSLocalizedString("Total:", comment: "") + String(describing: videoCategories!.total_videos!)
            
            titleLb.adjustsFontSizeToFitWidth = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
