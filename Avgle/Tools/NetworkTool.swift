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
    
    let videoCollectionsURL = "https://api.avgle.com/v1/collections/<page>"
    
    // MARK: - 讀取影片分類資料
    func loadVideoCategoriseData(finished: @escaping ([VideoCategoriesModel]) ->()) {
        
        SVProgressHUD.show(withStatus: "正在加載...")
        
        Alamofire.request(videoCategoriesURL, method: .get).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                SVProgressHUD.show(withStatus: "加載失敗...")
                return
            }
            
            if let value = response.result.value {
                
                let responseObject = (value as AnyObject) ["response"]
                let categoriesObject = (responseObject as AnyObject)["categories"]
                let categoriesArr = categoriesObject as! Array<Any>
                
                let dict = JSON(categoriesArr)
                    
                if let categories = dict.arrayObject {
                    
                    var categoriesModelArr = [VideoCategoriesModel]()
                    for categorie in categories {
                        
                        let oneCategorie = VideoCategoriesModel(dict: categorie as! [String : Any])
                        categoriesModelArr.append(oneCategorie)
                        SVProgressHUD.dismiss()
                    }
                    finished(categoriesModelArr)
                }
            }
        }
    }
    
    //MARK: - 讀取影片collection
//    func loadVideoCollectionData(finished: @escaping)
}
