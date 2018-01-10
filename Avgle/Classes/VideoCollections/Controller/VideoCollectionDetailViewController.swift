//
//  VideoCollectionDetailViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/9.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import SafariServices
import MJRefresh

class VideoCollectionDetailViewController: BaseViewController {

    // MARK: - Property
    
    struct PropertyKeys {
        
        static let collectionViewReuseIdentifier: String = "videoCollectionViewCell"
    }
    
    var page: Int = 0
    
    var limitData: Int = 0
    
    fileprivate lazy var collections: [VideoCollectionModel] = {
        let collections: Array = [VideoCollectionModel]()
        return collections
    }()
    
    fileprivate lazy var mainCollectionView: UICollectionView = {
        
        let y: CGFloat = kNavigationBarHeight + 20 //20狀態列
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: y, width: kScreenWidth, height: kScreenHeight - y), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: VideoCategoriesCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: VideoCollectionsViewController.PropertyKeys.collectionViewReuseIdentifier)
        collectionView.backgroundColor = Theme.baseBackgroundColor
        
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(dropDownLoad))
        header?.lastUpdatedTimeLabel.isHidden = false
        collectionView.mj_header = header
        
        let footer = MJRefreshBackFooter(refreshingTarget: self, refreshingAction: #selector(pullUpLoad))
        collectionView.mj_footer = footer
        
        return collectionView
    }()
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dropDownLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func setupNavigation() {
        super.setupNavigation()
        
        self.title = NSLocalizedString("Video Collection", comment: "")
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_0"), style: .plain, target: self, action: #selector(clickNavigationLeftBtn))
        leftBarButtonItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Theme.baseFontColor], for: .normal)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func clickNavigationLeftBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setup UI
    override func setUI() {
        super.setUI()
        
        view.addSubview(mainCollectionView)
    }
    
    // MARK: - Load Data
    
    @objc fileprivate func dropDownLoad() {
        limitData = 0
        loadDataWithDropDown()
    }
    
    @objc fileprivate func pullUpLoad() {
        limitData += 30
        loadDataWithPullUpLoad(limit: 30 + limitData)
    }
    
    fileprivate func loadDataWithDropDown() {
        
        mainCollectionView.mj_header.beginRefreshing()
        NetworkTool.share.loadVideoCollectionData(page: page, limit: 30) { [weak self](success, hasMore, data) in
            
            self!.collections = data
            self!.mainCollectionView.reloadData()
            self!.mainCollectionView.mj_header.endRefreshing()
            self!.mainCollectionView.mj_footer.resetNoMoreData()
        }
    }
    
    fileprivate func loadDataWithPullUpLoad(limit: Int) {
        
        mainCollectionView.mj_footer.beginRefreshing()
        NetworkTool.share.loadVideoCollectionData(page: page, limit: limit) { [weak self](success, hasMore, data) in
            
            self!.collections = data
            self!.mainCollectionView.reloadData()
            self!.mainCollectionView.mj_footer.endRefreshing()
            if !hasMore {
                self!.mainCollectionView.mj_footer.endRefreshingWithNoMoreData()
            }
        }
    }
}


extension VideoCollectionDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.collectionViewReuseIdentifier, for: indexPath) as! VideoCategoriesCollectionViewCell
        cell.videoCollection = collections[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let urlStr: String = collections[indexPath.item].collection_url!.urlEncoded()
        let safariVC = SFSafariViewController(url: URL(string: urlStr)!)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (kScreenWidth - 20) / 2
        let height: CGFloat = width * 0.56
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
}

extension VideoCollectionDetailViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
