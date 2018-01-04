//
//  VideoCollectionsViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/11/25.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import SafariServices

class VideoCollectionsViewController: BaseViewController {

    // MARK: - Property
    
    fileprivate lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        return scrollView
    }()
    
    fileprivate lazy var recommendVideosView: RecommendedVideosView = {
    
        let view = RecommendedVideosView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 180))
        view.recommendCollectionView.delegate = self
        view.recommendCollectionView.dataSource = self
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var recommendVideos: [VideoCollectionModel] = {
        let videos: Array = [VideoCollectionModel]()
        return videos
    }()
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Navigation
    
    override func setupNavigation() {
        super.setupNavigation()
        
        self.title = NSLocalizedString("Videos", comment: "")
    }

    // MARK: - UI
    
    override func setUI() {
        super.setUI()
        
        self.view.addSubview(mainScrollView)
        self.mainScrollView.addSubview(recommendVideosView)
        
        
//        self.mainScrollView.contentSize
        
    }
    
    // MARL: - Load Data
    
    fileprivate func loadData() {
        
        NetworkTool.share.loadVideoCollectionData(page: 0, limit: 12) { [weak self](success, hasMore, data) in
            
            self!.recommendVideos = data
            self!.recommendVideosView.recommendCollectionView.reloadData()
        }
        
        NetworkTool.share.loadVideoData(page: 0, limit: 12) { [weak self](success, hasMore, data) in
            
            
            
        }
    }
   
}

extension VideoCollectionsViewController: RecommendedVideosViewDelegate {
    
    func recommendedVideosViewClickMoreBtn(btn: UIButton) {
        
    }
}

extension VideoCollectionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCategoriesViewController.PropertyKeys.collectionViewReuseIdentifier, for: indexPath) as! VideoCategoriesCollectionViewCell
        cell.videoCollection = recommendVideos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let urlStr: String = recommendVideos[indexPath.item].collection_url!.urlEncoded()
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

extension VideoCollectionsViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
