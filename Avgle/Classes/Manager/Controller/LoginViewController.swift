//
//  LoginViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/2.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    //MARK: - Property
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var window: UIWindow?
    
    //MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }
    
    //MARK: - Button Action
    
    @IBAction func login(_ sender: Any) {
        
        guard
            let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != ""
            else {
            
                AlertControllerTool.alertView.showAlertViewWithOK(title: "Login Error", message: "Both fields must mot be blank.", viewController: self, okAction: nil)
                return
        }
        
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (user, error) in
            
            if let error = error {
                
                AlertControllerTool.alertView.showAlertViewWithOK(title: "Login Error", message: error.localizedDescription, viewController: self, okAction: nil)
                return
            }
            
            guard
                let currentUser = user, currentUser.isEmailVerified
                else {
                    
                    let okAction = UIAlertAction(title: NSLocalizedString("Resend email", comment: ""), style: .default, handler: { (action) in
                        user?.sendEmailVerification(completion: nil)
                    })
                    
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                    
                    AlertControllerTool.alertView.showAlertViewWithActionArray(title: "Login Error",
                                                                               message: "You haven't confirmed your email address yet. We sent you a confirmation email when you sign up. Please click the verification link in that email. If you need us to send the confirmation email again, please tap Resend Email.",
                                                                               viewController: self,
                                                                               actionArray: [okAction,cancelAction])
                    return
            }
            
            //移除鍵盤
            self.view.endEditing(true)
            
            //呈現主畫面
            goMainView(self)
//            UIApplication.shared.keyWindow?.rootViewController = BaseTabBarViewController()
//            self.dismiss(animated: true, completion: nil)
        }
    }
    
}