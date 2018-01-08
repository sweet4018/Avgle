//
//  RecommendedVideosView.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/3.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import SnapKit

protocol RecommendedVideosViewDelegate: NSObjectProtocol {
    
    ///點擊更多
    func recommendedVideosViewClickMoreBtn(btn: UIButton)
}

class RecommendedVideosView: UIView {

    // MARK: - Property
    
    weak var delegate: RecommendedVideosViewDelegate?
    
    fileprivate lazy var titleLb: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 15, y: 15, width: 0, height: 0))
        label.text = NSLocalizedString("Recommended Video", comment: "")
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var moreBtn: UIButton = {
        
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("Display More", comment: ""), for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.sizeToFit()
        button.addTarget(self, action: #selector(displayMore(button:)), for: .touchUpInside)
        return button
    }()
    
    lazy var recommendCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
    
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: VideoCategoriesCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: VideoCollectionsViewController.PropertyKeys.collectionViewReuseIdentifier)
        collectionView.backgroundColor = Theme.baseBackgroundColor
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    fileprivate lazy var lineView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLb)
        self.addSubview(moreBtn)
        self.addSubview(recommendCollectionView)
        self.addSubview(lineView)
        setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Action
    
    @objc func displayMore(button: UIButton) {
        
        self.delegate?.recommendedVideosViewClickMoreBtn(btn: button)
    }
    
    // MARK: - Auto Layout
    
    override func setNeedsLayout() {
        
        moreBtn.snp.makeConstraints({ (make) in
            make.width.equalTo(self.moreBtn.titleLabel!)
            make.height.equalTo(self.titleLb)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(self.titleLb.snp.bottom)
        })
        
        recommendCollectionView.snp.makeConstraints ({ (make) in
            make.width.equalTo(self)
            make.leading.equalTo(self)
            make.top.equalTo(self.titleLb.snp.bottom).offset(10)
            make.bottom.equalTo(self).offset(-5)
        })
        
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-2)
            make.height.equalTo(1)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
    }
}
