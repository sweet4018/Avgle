//
//  Commom.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/11/25.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit

///TabBar高度
let kTabBarHeight: CGFloat = (UIApplication.shared.statusBarFrame.size.height > 20.0 ? 83.0:49.0)

///螢幕寬度
let kScreenWidth = UIScreen.main.bounds.width

///螢幕高度
let kScreenHeight = UIScreen.main.bounds.height

///主題
struct theme {
    
    ///基本背景色
    static let baseBackgroundColor: UIColor = UIColor.white
    
    ///APP導航列barButtonItem文字大小
    static let NavItemFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    ///APP導航列titleFont文字大小
    static let NavTitleFont: UIFont = UIFont.systemFont(ofSize: 18)
    
    ///UIApplication.sharedApplication
    static let appShare = UIApplication.shared
}


/// RGBA的顏色設置
func CYColor(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}
