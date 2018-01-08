//
//  WelcomeViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/12/28.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class WelcomeViewController: BaseViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ""
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButton Action
    
    @IBAction func unwindtoWelcomeView(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                print("錯誤登入:\(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                
                print("無法得到使用者Token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            //呼叫 Firebase APIs 執行登入
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                
                if let error = error {
                    print("登入錯誤:\(error.localizedDescription)")
                    
                    AlertControllerTool.shared.showAlertViewWithOK(title: "Login Error", message: error.localizedDescription, viewController: self, okAction: nil)
                    return
                }
                //呈現主畫面
                goMainView(self)
                
            })
        }
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        //FIXME: Test
        //GIDSignIn.sharedInstance().signIn()
        
        goMainView(self)
    }
    
    //MARK: Google Login Delegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let error = error {
                print("登入失敗:\(error.localizedDescription)")
                
                AlertControllerTool.shared.showAlertViewWithOK(title: "Login Error", message: error.localizedDescription, viewController: self)
            }
            
            //呈現主畫面
            goMainView(self)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    

}
