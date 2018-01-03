//
//  VideoCategoriesViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/11/25.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import MJRefresh
import SafariServices

class VideoCategoriesViewController: BaseViewController {

    let collectionViewReuseIdentifier: String = "collectionViewCell"
    
    //MARK: - Property
    
    fileprivate lazy var videos: [VideoCategoriesModel] = {
        let video: Array = [VideoCategoriesModel]()
        return video
    }()
    
    fileprivate weak var mainCollectionView: UICollectionView?
    
    //MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //讀取資料
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Navigation
    
    override func setupNavigation() {
        super.setupNavigation()

        self.title = NSLocalizedString("Video Categories", comment: "")
    }
    
    //MARK: - UI
    
    override func setUI() {
        super.setUI()
        
        setCollectionView()
    }
    
    //MARK: UICollection
    fileprivate func setCollectionView() {

        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kTabBarHeight - kNavigationBarHeight), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "VideoCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionViewReuseIdentifier)
        collectionView.backgroundColor = theme.baseBackgroundColor
        
        self.view.addSubview(collectionView)
        
        self.mainCollectionView = collectionView
    
        //刷新
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(pullLoadCollectionView))
        header?.lastUpdatedTimeLabel.isHidden = false
        self.mainCollectionView?.mj_header = header
    }
    
    ///下拉刷新
    @objc fileprivate func pullLoadCollectionView() {
        //讀取資料
        loadData()
    }
    
    //MARK: - Load Data
    
    fileprivate func loadData() {
        
        self.mainCollectionView?.mj_header.beginRefreshing()
        NetworkTool.share.loadVideoCategoriseData {[weak self] (success, videoCategories) in

            self!.videos = videoCategories
            self!.mainCollectionView?.reloadData()
            self!.mainCollectionView?.mj_header.endRefreshing()
        }
    }

}

extension VideoCategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewReuseIdentifier, for: indexPath) as! VideoCategoriesCollectionViewCell
        cell.videoCategories = videos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let safariVC = SFSafariViewController(url: URL(string: videos[indexPath.item].category_url!)!)
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

extension VideoCategoriesViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

