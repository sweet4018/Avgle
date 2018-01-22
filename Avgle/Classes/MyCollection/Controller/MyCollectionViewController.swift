//
//  MyCollectionViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/22.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import Firebase
import SafariServices
import MJRefresh
import SwiftyJSON
import SVProgressHUD

class MyCollectionViewController: BaseViewController {

    // MARK: - Properties
    
    var ref: DatabaseReference!
    
    struct PropertyKeys {
        
        static let collectionViewReuseIdentifier: String = "VideosCollectionViewCell"
    }
    
    fileprivate lazy var videos: [VideoModel] = {
        let video: Array = [VideoModel]()
        return video
    }()
    
    /// 資料庫的Key要刪除時會用到
    fileprivate lazy var databaseKeys: [String] = {
       
        let array: Array = [String]()
        return array
    }()
    
    fileprivate lazy var mainCollectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: VideosCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: PropertyKeys.collectionViewReuseIdentifier)
        
        collectionView.backgroundColor = Theme.baseBackgroundColor
        
        
        return collectionView
    }()
    
    // MARK: - View Life Cycle
    
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
        
        title = NSLocalizedString("My Collection", comment: "")
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        super.setUI()
        
        view.addSubview(mainCollectionView)
        
        setDate()
        setNeedsLayout()
    }

    // MARK: - Auto Layout
    
    func setNeedsLayout() {
        
        mainCollectionView.snp.makeConstraints { (make) in
            make.bottom.leading.width.height.equalTo(view)
        }
    }
    
    // MARK: - Set Data
    
    func setDate() {
        
        ref = Database.database().reference()
        loadData()
    }
    
    // MARK: - function
    
    fileprivate func loadData() {
        
        self.videos.removeAll()
        self.databaseKeys.removeAll()
        
        SVProgressHUD.showProgress(3.0, status: NSLocalizedString("Loading...", comment: ""))
        
        let childKey = String((Auth.auth().currentUser?.displayName)! + "_" + (Auth.auth().currentUser?.uid)!)
        ref.child(childKey).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let json = JSON(snapshot.value!)
            if let result = json.dictionary {
                
                for data in result {
                    
                    self.databaseKeys.append(data.key)
                    self.videos.append(VideoModel(dict: data.value.dictionaryObject!))
                }
            }
            
            self.mainCollectionView.reloadData()
            SVProgressHUD.dismiss()
            
            
        }) { (error) in
            
            SVProgressHUD.dismiss()
            
            AlertControllerTool.shared.showAlertViewWithOK(title: "", message: error.localizedDescription, viewController: self)
        }
    }
}

extension MyCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.collectionViewReuseIdentifier, for: indexPath) as! VideosCollectionViewCell
        cell.video = videos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let preparePlayerVC = PreparePlayerViewController()
        preparePlayerVC.isFromCollection = true
        preparePlayerVC.dataKey = databaseKeys[indexPath.item]
        preparePlayerVC.video = videos[indexPath.item]
        self.present(preparePlayerVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (kScreenWidth - 20) / 2
        let height: CGFloat = width * 0.85
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
}

extension MyCollectionViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
