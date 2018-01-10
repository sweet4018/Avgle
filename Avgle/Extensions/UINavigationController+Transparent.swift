//
//  UINavigationController+Transparent.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/12/28.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
     
        
        // Make the navigation bar transparent
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        self.navigationBar.backgroundColor = .black
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Arial", size: 20)!,
                                                  NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    

}

