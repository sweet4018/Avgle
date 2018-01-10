//
//  SearchTopCollectionViewCell.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/9.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit

class SearchTopCollectionViewCell: UICollectionViewCell {

    // MARK: - Property
    static let className: String = "SearchTopCollectionViewCell"
    
    open var videoCollectionModel: VideoCollectionModel? {
        didSet {
            titleLb.text = videoCollectionModel!.title!
        }
    }
    
    @IBOutlet weak var titleLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
