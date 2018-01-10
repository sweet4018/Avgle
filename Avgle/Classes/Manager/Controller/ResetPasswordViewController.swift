//
//  ResetPasswordViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/2.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: BaseViewController {

    //MARK: - Property
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -Navigation
    
    override func setupNavigation() {
        super.setupNavigation()
    }
    
    //MARL: - Button Action
    @IBAction func resetPasswordAction(_ sender: Any) {
        
        //輸入驗證
        guard let emailAddress = emailTextField.text, emailAddress != "" else {
            
            AlertControllerTool.shared.showAlertViewWithOK(title: "Input Error", message: "Please provide your email address for password reset.", viewController: self, okAction: nil)
            return
        }
        
        //傳送重設密碼email
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            
            let title = (error == nil) ? "Password Reset Follow-up" : "Password Reset Error"
            
            let message = (error == nil) ? "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password." : error?.localizedDescription
            
            AlertControllerTool.shared.showAlertViewWithOK(title: title, message: message!, viewController: self, okAction: {
                if error == nil {
                    
                    //解除鍵盤
                    self.view.endEditing(true)
                    
                    //返回登入畫面
                    if let navController = self.navigationController {
                        
                        navController.popViewController(animated: true)
                    }
                }
            })
        }
    }
}
