//
//  AlertControllerTool.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/12/30.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit

class AlertControllerTool: NSObject {

    static let shared = AlertControllerTool()
    
    ///有一個OK的AlertView
    func showAlertViewWithOK(title: String, message: String, viewController:UIViewController, okAction: (() -> Swift.Void)? = nil) {
        
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: ""),
                                                message: NSLocalizedString(message, comment: ""),
                                                preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let okayAction = okAction {
                okayAction()
            }        
        }
        
        alertController.addAction(okayAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    /// 一個警告視窗，多個按鈕
    ///
    /// - Parameters:
    ///   - title: 標題
    ///   - message: 訊息
    ///   - viewController: 在哪個ViewConttoller
    ///   - actionArray: 動作陣列
    func showAlertViewWithActionArray(title: String, message: String, viewController: UIViewController, actionArray: Array<UIAlertAction>) {
        
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: ""),
                                                message: NSLocalizedString(message, comment: ""),
                                                preferredStyle: .alert)
        
        for action in actionArray {
            alertController.addAction(action)
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
//    func showAlertViewWithTextField(title: String, message: String, ViewController: UIViewControllerx)
    
}
