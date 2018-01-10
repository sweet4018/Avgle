//
//  BMPlayerCustomControlView.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/7.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//


import Foundation
import BMPlayer

class BMPlayerCustomControlView: BMPlayerControlView {
    
    var playTimeUIProgressView = UIProgressView()
    var playingStateLabel = UILabel()
    
    /**
     Override if need to customize UI components
     */
    override func customizeUIComponents() {
        // just make the view hidden
        backButton.isHidden = true
        chooseDefitionView.isHidden = true
        
        // or remove from superview
        playButton.removeFromSuperview()
        currentTimeLabel.removeFromSuperview()
        totalTimeLabel.removeFromSuperview()
        timeSlider.removeFromSuperview()
        
        // If needs to change position remake the constraint
        progressView.snp.remakeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomMaskView)
            make.height.equalTo(2)
        }
        
        // Add new items and constraint
        bottomMaskView.addSubview(playTimeUIProgressView)
        playTimeUIProgressView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomMaskView)
            make.height.equalTo(2)
        }
        
        playTimeUIProgressView.tintColor      = UIColor.red
        playTimeUIProgressView.trackTintColor = UIColor.clear

        addSubview(playingStateLabel)
        playingStateLabel.snp.makeConstraints {
            $0.left.equalTo(self).offset(10)
            $0.bottom.equalTo(self).offset(-10)
        }
        playingStateLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playingStateLabel.textColor = UIColor.white
        
        addSubview(fullscreenButton)
        fullscreenButton.snp.makeConstraints {
            $0.margins.equalTo(self.backButton)
        }
    }
    
    override func updateUI(_ isForFullScreen: Bool) {
        backButton.isHidden = true
        chooseDefitionView.isHidden = true
    }
    
    override func playTimeDidChange(currentTime: TimeInterval, totalTime: TimeInterval) {
        playTimeUIProgressView.setProgress(Float(currentTime/totalTime), animated: true)
    }

    override func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        // redirect tap action to play button action
        delegate?.controlView(controlView: self, didPressButton: playButton)
    }
    
    override func playStateDidChange(isPlaying: Bool) {
        super.playStateDidChange(isPlaying: isPlaying)

        
        playingStateLabel.text = isPlaying ? NSLocalizedString("Playing", comment: "") : NSLocalizedString("Paused", comment: "")
    }
    
    override func controlViewAnimation(isShow: Bool) {
        self.isMaskShowing = isShow
        UIApplication.shared.setStatusBarHidden(!isShow, with: .fade)
        
        UIView.animate(withDuration: 0.24, animations: {
            self.topMaskView.snp.remakeConstraints {
                $0.top.equalTo(self.mainMaskView).offset(isShow ? 0 : -65)
                $0.left.right.equalTo(self.mainMaskView)
                $0.height.equalTo(65)
            }
            
            self.layoutIfNeeded()
        }) { (_) in
            self.autoFadeOutControlViewWithAnimation()
        }
    }
    
    
}
