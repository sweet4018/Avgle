//
//  AlertControllerTool.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/12/30.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit

class AlertControllerTool: NSObject {

    static let alertView = AlertControllerTool()
    
    ///有一個OK的AlertView
    func showAlertViewWithOK (title: String, message: String, viewController:UIViewController, okAction: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: ""),
                                                message: NSLocalizedString(message, comment: ""),
                                                preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default) { (action) in
            okAction()
        }
        
        alertController.addAction(okayAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
