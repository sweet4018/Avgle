//
//  BaseNavigationViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/11/25.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer!.delegate = nil
        
        setupNavigationStyle()
    }
    
    func setupNavigationStyle() {

        //設置導航列主題
        let navAppearance = UINavigationBar.appearance()
        // 設置導航titleView字體
        navAppearance.isTranslucent = false
        navAppearance.titleTextAttributes = [NSAttributedStringKey.font : Theme.NavTitleFont, NSAttributedStringKey.foregroundColor : Theme.baseFontColor]
        navAppearance.barTintColor = Theme.baseBackgroundColor
        let item = UIBarButtonItem.appearance()
        item.setTitleTextAttributes([NSAttributedStringKey.font : Theme.NavItemFont, NSAttributedStringKey.foregroundColor : Theme.baseBackgroundColor], for: .normal)
    }

    lazy var backBtn : UIButton = {
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backBtn.setTitleColor(UIColor.black, for: .normal)
        backBtn.setImage(UIImage(named:"back_1"), for: .normal)
        backBtn.addTarget(self, action: #selector(BaseNavigationViewController.backBtnClick), for: .touchUpInside)
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
        backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        let btnW : CGFloat = kScreenWidth > 375.0 ? 50 : 44
        backBtn.frame = CGRect(x: 0, y: 0, width: btnW, height: 40)
        
        return backBtn
    }()
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.childViewControllers.count > 0 {
            
            backBtn.setTitle(self.title, for: .normal)
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func backBtnClick() {
        self.popViewController(animated: true)
    }
}
