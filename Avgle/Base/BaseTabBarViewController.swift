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
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    fileprivate func setupAllChildViewController() {
        
        tabBarAddChildViewController(vc: VideosViewController(), title: "Videos", imageName: "tabBar_VideoCategories_0", selectedImageName: "tabBar_VideoCategories_0")
        
        tabBarAddChildViewController(vc: VideoCollectionsViewController(), title: "Video Collection", imageName: "tabBar_VideoCollections_0", selectedImageName: "tabBar_VideoCollections_0")
        
        tabBarAddChildViewController(vc: MeViewController(), title: "Me", imageName: "tabBar_Me_0", selectedImageName: "tabBar_Me_1")
        
    }

    fileprivate func tabBarAddChildViewController(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
        
        vc.tabBarItem = UITabBarItem(title: NSLocalizedString(title, comment: ""), image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        let navVC = BaseNavigationViewController(rootViewController: vc)
        addChildViewController(navVC)
    }
    
    /** 限制直向 */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return  .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

class BaseTabBar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isTranslucent = true
        self.barStyle = .black
        self.tintColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

