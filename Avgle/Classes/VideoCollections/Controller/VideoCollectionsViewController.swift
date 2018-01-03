//
//  VideoCollectionsViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/11/25.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit

class VideoCollectionsViewController: BaseViewController {

    // MARK: - Property
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
  
    }
    
    // MARK: - Navigation
    
    override func setupNavigation() {
        super.setupNavigation()
        
        self.title = NSLocalizedString("Videos", comment: "")
    }

    // MARK: - UI
    
    override func setUI() {
        super.setUI()
        
        
    }
    
    // MARL: - Load Data
    
    fileprivate func loadData() {
        NetworkTool.share.loadVideoCollectionData(page: 1, limit: 3) { (success, hasMore, data) in
            
            
            
        }
    }
   

}
