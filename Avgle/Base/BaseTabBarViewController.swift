//
//  BaseViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/11/25.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAllChildViewController()
        self.setValue(BaseTabBar(), forKey: "tabBar")        
    }
    
    fileprivate func setupAllChildViewController() {
        
        tabBarAddChildViewController(vc: VideoCategoriesViewController(), title: "影片分類", imageName: "tabBar_VideoCategories_0", selectedImageName: "tabBar_VideoCategories_1")
        
        tabBarAddChildViewController(vc: VideoCollectionsViewController(), title: "影片集", imageName: "tabBar_VideoCollections_0", selectedImageName: "tabBar_VideoCollections_1")
        
        tabBarAddChildViewController(vc: MeViewController(), title: "我的", imageName: "tabBar_Me_0", selectedImageName: "tabBar_Me_1")
        
    }

    fileprivate func tabBarAddChildViewController(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
        
        
        
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        let navVC = BaseNavigationViewController(rootViewController: vc)
        addChildViewController(navVC)
    }
}

class BaseTabBar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isTranslucent = true
        self.backgroundImage = UIImage(named: "tabbar")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

