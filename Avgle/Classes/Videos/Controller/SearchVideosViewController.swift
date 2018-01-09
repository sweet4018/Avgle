//
//  SearchVideosViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/9.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import MJRefresh

class SearchVideosViewController: BaseViewController {

    // MARK: - Property
    
    var query: String = ""
    
    var page: Int = 0
    
    var testLabel = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    
    struct PropertyKeys {
        
        static let collectionViewReuseIdentifier: String = "VideosCollectionViewCell"
    }
    
    fileprivate lazy var searchController: UISearchController = {
       
        let search = UISearchController(searchResultsController: nil)
        
        
        search.bar
        
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.barTintColor = .darkGray
        search.searchBar.delegate = self
        return search
    }()
    
    fileprivate lazy var videos: [VideoModel] = {
        let video: Array = [VideoModel]()
        return video
    }()
    
    fileprivate lazy var mainCollectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: VideosCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: PropertyKeys.collectionViewReuseIdentifier)
        collectionView.backgroundColor = Theme.baseBackgroundColor
        let footer = MJRefreshBackFooter(refreshingTarget: self, refreshingAction: #selector(loadDataWtihPullUp))
        collectionView.mj_footer = footer
        return collectionView
    }()
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Navigation

    override func setupNavigation() {
        super.setupNavigation()

        self.title = NSLocalizedString("Search", comment: "")
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_0"), style: .plain, target: self, action: #selector(clickNavigationLeftBtn))
        leftBarButtonItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Theme.baseFontColor], for: .normal)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func clickNavigationLeftBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UI
    
    override func setUI() {
        super.setUI()
        
        view.addSubview(searchController.searchBar)
        view.addSubview(mainCollectionView)
        
        setNeedsLayout()
    }
    
    // MARK: - Auto Layout
    
    func setNeedsLayout() {
        
        mainCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(56) //SerachBar基本高度為56
            make.width.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    //MARK: - Load Data
    
    @objc fileprivate func loadDataWtihPullUp() {
        
        page += 1
        loadData(reset: false)
    }
    
    fileprivate func loadData(reset: Bool) {
        
        if reset {
            page = 0
            mainCollectionView.mj_footer.resetNoMoreData()
        }
        
        self.mainCollectionView.mj_footer.beginRefreshing()
        NetworkTool.share.loadVideoDataWithSearch(query: query, page: page) { [weak self](success, hasMore, data) in
            
            if !hasMore || data.count == 0 {
                self!.mainCollectionView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            if reset {
                self!.videos = data
            } else {
                self!.videos += data
            }
            
            self!.mainCollectionView.reloadData()
            self!.mainCollectionView.mj_footer.endRefreshing()
        }
    }
}

extension SearchVideosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

extension SearchVideosViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchController.searchBar.text {
            
            query = searchText
            loadData(reset: true)
        }
    }
}
