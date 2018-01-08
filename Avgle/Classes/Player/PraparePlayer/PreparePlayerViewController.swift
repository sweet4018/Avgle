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

class PreparePlayerViewController: BaseViewController {

    // MARK: - Property
    
    var video: VideoModel? {
        didSet {
            
            let url = URL(string: (video!.preview_video_url?.urlEncoded())!)!
            let asset = BMPlayerResource(url: url, name: video!.title!)
            player.seek(30)
            player.setVideo(resource: asset)
        }
    }
    
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
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)                
        return btn
    }()
    
    fileprivate lazy var watchTheVideoBtn: UIButton = {
        
        let btn = UIButton(type: .custom)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.setTitle("Watch the video", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(watchFullVideo), for: .touchUpInside)
        
        return btn
    }()
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Animation
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translate = CGAffineTransform(translationX: 0, y: 500)
        self.watchTheVideoBtn.transform = scale.concatenating(translate)
        self.cancelBtn.transform = scale.concatenating(translate)
        self.player.transform = scale.concatenating(translate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Animation
        UIButton.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            
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
        
        resetPlayerManager()
        
        setNeedsLayout()
    }
    

    // MARK: - Button Action
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }

    @objc func watchFullVideo() {
        
        let urlStr: String = self.video!.embedded_url!.urlEncoded()
        let safariVC = SFSafariViewController(url: URL(string: urlStr)!)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
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
        player.snp.remakeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            if isFullscreen {
                make.bottom.equalTo(view.snp.bottom)
            } else {
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
