//
//  SignUpViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/12/30.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerAccount: LineButton!
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Sign Up", comment: "")
        nameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action    
    @IBAction func registerAccountAction(_ sender: Any) {
        
        //輸入驗證
        guard
            let name = nameTextField.text, name != "",
            let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "" else {
                
                AlertControllerTool.alertView.showAlertViewWithOK(title: "Registration Error", message: "Please make sure you provide your name, email address and password to complete the registration.", viewController: self, okAction: {})
                return
        }
        
        //在Firebase註冊使用者帳號
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (user, error) in

            if let error = error {
                
                AlertControllerTool.alertView.showAlertViewWithOK(title: "Registration", message: error.localizedDescription, viewController: self,okAction: {})
                return
            }
            
            //儲存使用者名稱
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { (error) in
                    
                    if let error = error {
                        print("Failed to change the display name:\(error.localizedDescription)")
                    }
                })
            }
            
            //移除鍵盤
            self.view.endEditing(true)
            
            //傳送認證信
            user?.sendEmailVerification(completion: nil)
            AlertControllerTool.alertView.showAlertViewWithOK(title: "Email Verification", message: "We've just sent a confirmation email to your email address. Please check your inbox and click the verification link in that email to complete the sign up", viewController: self, okAction: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
}
