//
//  PreparePlayerViewController.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/7.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import BMPlayer
import SafariServices
import Firebase
import SVProgressHUD

class PreparePlayerViewController: BaseViewController {

    // MARK: - Property
    
    /// 是否從收藏進來的，此頁面可由主頁及我的收藏兩個地方進來，分不同模式，在likeBtn有不同呈現
    public var isFromCollection: Bool = false
    
    /// 若需要刪除會有key
    public var dataKey: String = ""
    
    var video: VideoModel? {
        didSet {
            
            let url = URL(string: (video!.preview_video_url?.urlEncoded())!)!
            let asset = BMPlayerResource(url: url, name: video!.title!)
            player.seek(30)
            player.setVideo(resource: asset)
        }
    }
    
    var ref: DatabaseReference!
    
    fileprivate lazy var player: BMPlayer = {
       
        let player = BMPlayer(customControlView: BMPlayerCustomControlView())
        player.delegate = self
        return player
    }()
    
    fileprivate lazy var blurEffectView: UIVisualEffectView = {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        return blurEffectView
    }()
    
    fileprivate lazy var backgroundImageView: UIImageView = {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        imageView.image = UIImage(named: "BG_3")
        imageView.addSubview(blurEffectView)
        return imageView
    }()
    
    fileprivate lazy var cancelBtn: UIButton = {
       
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.clear
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.setTitle(NSLocalizedString("Cancel", comment: "") , for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)                
        return btn
    }()
    
    fileprivate lazy var watchTheVideoBtn: UIButton = {
        
        let btn = UIButton(type: .custom)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.setTitle(NSLocalizedString("Watch the video", comment: ""), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(watchFullVideo), for: .touchUpInside)
        
        return btn
    }()
    
    fileprivate lazy var likeBtn: UIButton = {
        
        let btn = UIButton(type: .custom)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.setTitle(NSLocalizedString(isFromCollection ? "Delete The Video":"Add My Collection", comment: ""), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(likeAction(btn:)), for: .touchUpInside)
        
        return btn
    }()
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Animation
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translate = CGAffineTransform(translationX: 0, y: 500)
        self.likeBtn.transform = scale.concatenating(translate)
        self.watchTheVideoBtn.transform = scale.concatenating(translate)
        self.cancelBtn.transform = scale.concatenating(translate)
        self.player.transform = scale.concatenating(translate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources t hat can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Animation
        UIButton.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            
            self.likeBtn.transform = CGAffineTransform.identity
            self.watchTheVideoBtn.transform = CGAffineTransform.identity
            self.cancelBtn.transform = CGAffineTransform.identity
            self.player.transform = CGAffineTransform.identity
        }, completion: nil)
    
    }
    
    // MARK : - Setup UI
    
    override func setUI() {
        super.setUI()
        
        view.addSubview(backgroundImageView)
        view.addSubview(cancelBtn)
        view.addSubview(watchTheVideoBtn)
        view.addSubview(player)
        view.addSubview(likeBtn)
        
        resetPlayerManager()
        
        setNeedsLayout()
        
        setData()
    }
    
    func setData() {
        
        ref = Database.database().reference()
    }
    
    // MARK: - Button Action
    
    @objc func cancelAction() {
        
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        dismiss(animated: true, completion: nil)
        
    }

    @objc func watchFullVideo() {
        
        let urlStr: String = self.video!.embedded_url!.urlEncoded()
        let safariVC = SFSafariViewController(url: URL(string: urlStr)!)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
    
    @objc func likeAction(btn: UIButton) {
        
        btn.isEnabled = false
                
        SVProgressHUD.showProgress(2.0, status: NSLocalizedString("Loading...", comment: ""))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            SVProgressHUD.dismiss()
            btn.setTitle(NSLocalizedString(self.isFromCollection ? "Successfully deleted":"Added successfully", comment: ""), for: .normal)
        }
        
        // 節點值
        let childKey: String = (Auth.auth().currentUser?.displayName)! + "_" + (Auth.auth().currentUser?.uid)!
        
        if self.isFromCollection {
            // 刪除            
            ref.child(childKey).child(dataKey).removeValue()
            
        } else {
            // 新增
            
            // 獲得現在日期
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyyMMdd_hh:mm:ss"
            let nowDate: String = dateFormatterPrint.string(from: Date())
            
            let dataDic: [String : Any] = ["title": video!.title!,
                                           "duration": video!.duration!,
                                           "likes": video!.likes!,
                                           "dislikes": video!.dislikes!,
                                           "embedded_url": video!.embedded_url!,
                                           "preview_url": video!.preview_url!,
                                           "preview_video_url": video!.preview_video_url!]
            // 上傳Database
            ref.child(childKey).child(nowDate).setValue(dataDic)
            
        }
    }
    
    // MARK: - Player
    
    func resetPlayerManager() {
    
        BMPlayerConf.shouldAutoPlay = true
        BMPlayerConf.tintColor = UIColor.white
        BMPlayerConf.topBarShowInCase = .none
    }
    
    // MARK: - Auto Layout
    
     func setNeedsLayout() {
        
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-30 * proportion).priority(1000)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.height.equalTo(50)
        }
        
        watchTheVideoBtn.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(cancelBtn)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-30)
        }
        
        likeBtn.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(cancelBtn)
            make.bottom.equalTo(watchTheVideoBtn.snp.top).offset(-30)
        }
        
        player.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
        }
    }
    
    // MARK: Device Orientation
    
    override var shouldAutorotate: Bool {
        return true
    }
}

extension PreparePlayerViewController: BMPlayerDelegate {
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        player.snp.remakeConstraints { [weak self](make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            if isFullscreen {
                self?.likeBtn.isHidden = true
                make.bottom.equalTo(view.snp.bottom)
            } else {
                self?.likeBtn.isHidden = false
                make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
            }
        }
    }
    
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
    }
    
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
        
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        //        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        //        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
    }
}

extension PreparePlayerViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
