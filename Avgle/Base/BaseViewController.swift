//
//  BaseViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/11/25.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import SVProgressHUD
import FDFullscreenPopGesture

class BaseViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setUI()
        
        view.backgroundColor = Theme.baseBackgroundColor
        navigationController?.fd_prefersNavigationBarHidden = true
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.setBackgroundColor(UIColor.gray)
        SVProgressHUD.setForegroundColor(UIColor.white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    func setupNavigation() {
        
        
    }

    
    // MARK: - Setup UI
    
    func setUI() {
        
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }
    
    // MARK: Device Orientation
    
//    /** 限制直向 */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
//
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return  .portrait
//    }
//
    override var shouldAutorotate: Bool {
        return false
    }
}
