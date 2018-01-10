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
    
    struct PropertyKeys {
        
        static let collectionViewReuseIdentifier: String = "VideosCollectionViewCell"
        static let topSearchcollectionViewReuseIdentifier: String = "SearchTopCollectionViewCell"
    }
    
    fileprivate lazy var searchController: UISearchController = {
       
        let search = UISearchController(searchResultsController: nil)
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.barTintColor = Theme.baseBackgroundColor
        search.searchBar.delegate = self
        let attributes = [NSAttributedStringKey.foregroundColor : Theme.baseFontColor]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        return search
    }()
    
    fileprivate lazy var videos: [VideoModel] = {
        let video: Array = [VideoModel]()
        return video
    }()
    
    fileprivate lazy var topSearchArr: [VideoCollectionModel] = {
        let arr: Array = [VideoCollectionModel]()
        return arr
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
    
    fileprivate lazy var topSearchCollectionView: UICollectionView = {
        
        let y: CGFloat = kNavigationBarHeight + 20 + 56 //56為searchBar高度
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: y, width: kScreenWidth, height: 30 * 6), collectionViewLayout: UICollectionViewFlowLayout()) //height:30 * 7 是因為一行30的高度有三筆資料總共只搜尋18筆
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: SearchTopCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: PropertyKeys.topSearchcollectionViewReuseIdentifier)
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

        self.title = NSLocalizedString("Search", comment: "")
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_0"), style: .plain, target: self, action: #selector(clickNavigationLeftBtn))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func clickNavigationLeftBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UI
    
    override func setUI() {
        super.setUI()
        
        loadDataWithTopSearch()
        
        view.addSubview(searchController.searchBar)
        view.addSubview(mainCollectionView)
        searchController.view.addSubview(topSearchCollectionView)
        
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
    
    fileprivate func loadDataWithTopSearch() {
        
        NetworkTool.share.loadVideoCollectionData(page: 0, limit: 21) { [weak self](success, hasMore, data) in
            self!.topSearchArr = data
            self!.topSearchCollectionView.reloadData()
        }
    }
}

extension SearchVideosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == mainCollectionView {
            return videos.count
        } else {
            return topSearchArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mainCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.collectionViewReuseIdentifier, for: indexPath) as! VideosCollectionViewCell
            cell.video = videos[indexPath.item]
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.topSearchcollectionViewReuseIdentifier, for: indexPath) as! SearchTopCollectionViewCell
            if topSearchArr.count > 0 {
                cell.videoCollectionModel = topSearchArr[indexPath.item]
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == mainCollectionView {
            let preparePlayerVC = PreparePlayerViewController()
            preparePlayerVC.video = videos[indexPath.item]
            self.present(preparePlayerVC, animated: true, completion: nil)
        } else {
            let key: String = topSearchArr[indexPath.item].title!
            searchController.searchBar.text = key
            query = key
            loadData(reset: true)
            searchController.searchBar.endEditing(true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == mainCollectionView {
            let width: CGFloat = (kScreenWidth - 20) / 2
            let height: CGFloat = width * 0.85
            return CGSize(width: width, height: height)
        } else {
            let width: CGFloat = (kScreenWidth - 20) / 3.5
            let height: CGFloat = 30
            return CGSize(width: width, height: height)
        }
        
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
