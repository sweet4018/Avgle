//
//  VideosController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/11/25.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import MJRefresh
import SafariServices

class VideosViewController: BaseViewController {
    
    //MARK: - Property
    
    
    struct PropertyKeys {
        
        static let collectionViewReuseIdentifier: String = "VideosCollectionViewCell"
    }
    
    fileprivate lazy var videos: [VideoModel] = {
        let video: Array = [VideoModel]()
        return video
    }()
    
    fileprivate lazy var mainCollectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kTabBarHeight - kNavigationBarHeight), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: VideosCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: PropertyKeys.collectionViewReuseIdentifier)
        collectionView.backgroundColor = Theme.baseBackgroundColor
        return collectionView
    }()
    
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

        self.title = NSLocalizedString("Videos", comment: "")
    }
    
    //MARK: - UI
    
    override func setUI() {
        super.setUI()
        
        setCollectionView()
    }
    
    //MARK: UICollection
    fileprivate func setCollectionView() {
        
        self.view.addSubview(mainCollectionView)
        
        //刷新
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(pullLoadCollectionView))
        header?.lastUpdatedTimeLabel.isHidden = false
        self.mainCollectionView.mj_header = header
    }
    
    ///下拉刷新
    @objc fileprivate func pullLoadCollectionView() {
        //讀取資料
        loadData()
    }
    
    //MARK: - Load Data
    
    fileprivate func loadData() {
        
        self.mainCollectionView.mj_header.beginRefreshing()
        
        NetworkTool.share.loadVideoData(page: 0, limit: 10) { [weak self] (success, hasMore, data) in
            
            self!.videos = data
            self!.mainCollectionView.reloadData()
            self!.mainCollectionView.mj_header.endRefreshing()
        }
        
//        NetworkTool.share.loadVideoCategoriseData {[weak self] (success, data) in
//
//            self!.videos = data
//            self!.mainCollectionView.reloadData()
//            self!.mainCollectionView.mj_header.endRefreshing()
//        }
    }
}

extension VideosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.collectionViewReuseIdentifier, for: indexPath) as! VideosCollectionViewCell
        cell.video = videos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let urlStr: String = videos[indexPath.item].video_url!.urlEncoded()
//        let safariVC = SFSafariViewController(url: URL(string: urlStr)!)
//        safariVC.delegate = self
//        self.present(safariVC, animated: true, completion: nil)
        let preparePlayerVC = PreparePlayerViewController()
        preparePlayerVC.video = videos[indexPath.item]
//        self.navigationController?.pushViewController(preparePlayerVC, animated: true)
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

extension VideosViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

