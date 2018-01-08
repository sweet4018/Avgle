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
    
    //當前頁數
    var currentPage: Int! = 0
    
    //總頁數
    var totalPage: Int! = 1
    
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
    
    fileprivate lazy var selectPageAlertController: UIAlertController = {
       
        let alertController = UIAlertController(title: NSLocalizedString("Please Select one/a  Page", comment: ""),
                                                          message: NSLocalizedString("Range", comment: "") + " 1~" + String(totalPage),
                                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            let enterMessageTextField = alertController.textFields![0]
            
            guard
                let text = enterMessageTextField.text,
                text != "", text != "0" else {
            
                return
            }
            
            self.currentPage = Int(text)! - 1
            self.loadDataWtihDropDown()
            self.updateNavLeftBtnTitle(page: self.currentPage + 1)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        alertController.addTextField(configurationHandler: { (textField: UITextField) in
            textField.placeholder = NSLocalizedString("Pages", comment: "")
            textField.keyboardType = .numberPad
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }()

    //MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //讀取資料
        loadDataWtihDropDown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Navigation
    
    override func setupNavigation() {
        super.setupNavigation()

        self.title = NSLocalizedString("Videos", comment: "")
        setupNavBtn()
    }
    
    fileprivate func setupNavBtn() {
        
        let barButtonItem =  UIBarButtonItem(title: getNavleftBtnName(page: 1), style: .plain, target: self, action: #selector(clickNavigationLeftBtn))
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Theme.baseFontColor], for: .normal)
        self.navigationItem.leftBarButtonItem = barButtonItem
    }

    ///獲得Navigation 左方按鈕標題（因中文跟英文順序顛倒，英文:Page 1，中文:1頁）
    fileprivate func getNavleftBtnName(page: Int) -> String {
        
        let name: String
        let pre = Locale.preferredLanguages[0]
        
        if pre == "en" {
            name = NSLocalizedString("Page", comment: "") + String(page)
        } else {
            name = String(page) + NSLocalizedString("Page", comment: "")
        }
        return name
    }
    
    fileprivate func updateNavLeftBtnTitle(page: Int) {
        
        self.navigationItem.leftBarButtonItem?.title = getNavleftBtnName(page: page)
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
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(dropDownLoad))
        header?.lastUpdatedTimeLabel.isHidden = false
        self.mainCollectionView.mj_header = header

        let footer = MJRefreshBackFooter(refreshingTarget: self, refreshingAction: #selector(pullUpLoad))
        self.mainCollectionView.mj_footer = footer
    }
    
    ///下拉刷新
    @objc fileprivate func dropDownLoad() {
        
        loadDataWtihDropDown()
    }
    
    ///上拉刷新
    @objc fileprivate func pullUpLoad() {
        
        loadDataWtihPullUp()
    }
    
    //MARK: - Load Data
    
    fileprivate func loadDataWtihDropDown() {
        
        self.mainCollectionView.mj_header.beginRefreshing()
        NetworkTool.share.loadVideoData(page: currentPage, limit: 26) { [weak self] (success, hasMore, totalVideo, data) in
            
            self?.totalPage = totalVideo / 50 //因一頁影片是50，所以拿總數來除50得到總頁數
            self!.videos.removeAll()
            self!.videos = data
            self!.mainCollectionView.reloadData()
            self!.mainCollectionView.mj_header.endRefreshing()
            self!.mainCollectionView.mj_footer.resetNoMoreData()
        }
    }
    
    fileprivate func loadDataWtihPullUp() {
        
        self.mainCollectionView.mj_footer.beginRefreshing()
        NetworkTool.share.loadVideoData(page: currentPage, limit: 50) { [weak self] (success, hasMore, totalVideo, data) in
            
            self?.totalPage = totalVideo / 50 //因一頁影片是50，所以拿總數來除50得到總頁數
            self!.videos = data
            self!.mainCollectionView.reloadData()
            self!.mainCollectionView.mj_footer.endRefreshing()
            self!.mainCollectionView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
    // MARK: - Button Action
    
    @objc func clickNavigationLeftBtn() {
        present(selectPageAlertController, animated: true, completion: nil)
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

extension VideosViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

