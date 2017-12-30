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
        
        
        
        
        
    }
    

}
