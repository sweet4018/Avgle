//
//  NetworkTool.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/11/25.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class NetworkTool: NSObject {

    static let share = NetworkTool()
    
    let videoCategoriesURL = "https://api.avgle.com/v1/categories"
    
    let videoCollectionsURL = "https://api.avgle.com/v1/collections/"
    
    // MARK: - 讀取影片分類資料
    func loadVideoCategoriseData(finished: @escaping (_ success: Bool ,[VideoCategoriesModel]) ->()) {
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Loading...", comment: ""))
        
        Alamofire.request(videoCategoriesURL, method: .get).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                SVProgressHUD.show(withStatus: NSLocalizedString("Failed to load...", comment: ""))
                finished(false, [])
                SVProgressHUD.dismiss()
                return
            }
            
            let json = JSON(response.result.value!)
            
            if let result = json["response"]["categories"].array {
             
                var categoriesModelArr = [VideoCategoriesModel]()
                for categorie in result {
                    
                    let oneCategorie = VideoCategoriesModel(dict: categorie.dictionaryObject!)
                    categoriesModelArr.append(oneCategorie)
                    
                }
                SVProgressHUD.dismiss()
                finished(true ,categoriesModelArr)
            }
        }
    }
    
    //MARK: - 讀取影片collection
    func loadVideoCollectionData(page: Int, limit: Int, finished: @escaping(_ success: Bool,_ hasMore: Bool,_ data: [VideoCollectionModel]) ->()) {
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Loading...", comment: ""))
        
        let url = videoCollectionsURL + String(page) + "?limit=" + String(limit)
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
         
            guard response.result.isSuccess else {
                SVProgressHUD.show(withStatus: NSLocalizedString("Failed to load...", comment: ""))
                finished(false, false, [])
                SVProgressHUD.dismiss()
                return
            }
            
            let json = JSON(response.result.value!)
            let hasMore: Bool = json["response"]["has_more"].bool!
            if let result = json["response"]["collections"].array {
                
                    var collectionModelArr = [VideoCollectionModel]()
                    for collection in result {
                        
                        let oneCollection = VideoCollectionModel(dict: collection.dictionaryObject!)
                        collectionModelArr.append(oneCollection)
                    }
                    SVProgressHUD.dismiss()
                    finished(true,hasMore,collectionModelArr)
            }
        }
    }
}
