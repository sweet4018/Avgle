//
//  MeViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/11/25.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import Firebase

class MeViewController: BaseViewController {

    // MARK: - Property
    
    fileprivate lazy var backgroundImageView: UIImageView = {
       
        let imageView = UIImageView(frame: view.bounds)
        imageView.image = UIImage(named: "BG_3")
        imageView.alpha = 0.5
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate lazy var myCollectionBtn: UIButton = {
       
        let button = LineButton(frame: CGRect(x: kScreenWidth * 0.1,
                                            y: kScreenHeight * 0.8,
                                            width: kScreenWidth * 0.8,
                                            height: 50))
        
        button.backgroundColor = CYColor(r: 46, g: 204, b: 113, a: 1.0)
        button.cornerRadius = 25
        button.setTitle(NSLocalizedString("My Collection", comment: ""), for: .normal)
        
        button.addTarget(self, action: #selector(clickMyCollectionBtn), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var titleLb: UILabel = {
       
        let label = UILabel(frame: CGRect(x: kScreenWidth * 0.25,
                                          y: kScreenHeight * 0.15,
                                          width: kScreenWidth * 0.5,
                                          height: 35))
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24)
        
        if let currentUser = Auth.auth().currentUser {
            
            label.text = NSLocalizedString("Hello", comment: "") +  " " + currentUser.displayName!
        }
        
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func setupNavigation() {
        super.setupNavigation()
        
        self.title = NSLocalizedString("Me", comment: "")
        
        let rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("LOGOUT", comment: ""), style: .plain, target: self, action: #selector(clickNavRightBtn))
        rightBarButtonItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Theme.baseFontColor], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func clickNavigationLeftBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setup UI
    override func setUI() {
        super.setUI()
        
        view.addSubview(backgroundImageView)
        view.addSubview(titleLb)
        view.addSubview(myCollectionBtn)
    }
    
    // MARK: - Button
    
    @objc func clickNavRightBtn() {
        
        do {
            try Auth.auth().signOut()
        } catch {

            AlertControllerTool.shared.showAlertViewWithOK(title: NSLocalizedString("Logout Error", comment: ""), message: error.localizedDescription, viewController: self)
            return
        }
        
        let story: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = story?.instantiateViewController(withIdentifier: "WelcomeView") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
    }
    
    @objc func clickMyCollectionBtn() {
        
    }
    
}
