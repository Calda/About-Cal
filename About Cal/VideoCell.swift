//
//  VideoCell.swift
//  About Cal
//
//  Created by Cal on 4/18/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

let VIDEO_PLAY_TOGGLE_NOTIFICATION = "VIDEO_PLAY_TOGGLE_NOTIFICATION"
let PAUSE_ALL_NOTIFICATION = "PAUSE_ALL_NOTIFICATION"
let BACKGROUND_QUEUE = DispatchQueue(label: "Background serial queue", attributes: [])

class VideoCell : ModuleCell {
    
    @IBOutlet weak var playButton: UIImageView!
    @IBOutlet weak var firstFrame: UIImageView!
    
    @IBOutlet weak var videoContainer: UIView!
    var playing = false
    var player : AVPlayer?
    var currentData : String?
    
    override func moduleType() -> ModuleType {
        return .video
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(VideoCell.videoToggeNotificationRecieved(_:)), name: NSNotification.Name(rawValue: VIDEO_PLAY_TOGGLE_NOTIFICATION), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(VideoCell.pauseAllNotificationRecieved), name: NSNotification.Name(rawValue: PAUSE_ALL_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(VideoCell.videoEnded(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func displayWithData(_ data: String) {
        if data != "molio" { //molio is the exception to everything
            if currentData == data { return }
            currentData = data
        }
        
        var videoName : String = data
        
        if data.hasPrefix("~") {
            playButton.image = UIImage(named: "playButtonWhite")
            videoName = String(data[videoName.index(after: videoName.startIndex)...])
        }
        playButton.isHidden = false
        playing = false
        player?.pause()
        
        let path = Bundle.main.path(forResource: videoName, ofType: "mov")!
        let url = URL(fileURLWithPath: path)
        firstFrame.image = UIImage(named: "\(videoName)-frame1")!
        firstFrame.isHidden = false
        
        BACKGROUND_QUEUE.async(execute: {
            for subview in self.videoContainer.subviews {
                subview.removeFromSuperview()
            }
            let playerController = AVPlayerViewController()
            playerController.view.frame.size = CGSize(width: self.frame.width, height: self.frame.height * 2)
            playerController.view.frame.origin = CGPoint(x: 0, y: -self.frame.height / 2)
            
            
            //I probably should have done this dynamically but I got lazy. Oops.
            
            if data == "~squareifyExample"{ //weird shaped video
                playerController.view.frame.size = CGSize(width: self.frame.width * 0.51, height: self.frame.height * 2)
                playerController.view.frame.origin = CGPoint(x: (self.frame.width - playerController.view.frame.width) / 2.0, y: -self.frame.height / 2)
                self.firstFrame.frame = playerController.view.frame
            }
            
            if data == "~instagramExample" { //weird shaped video
                playerController.view.frame.size = CGSize(width: self.frame.width * 0.6, height: self.frame.height * 2)
                playerController.view.frame.origin = CGPoint(x: (self.frame.width - playerController.view.frame.width) / 2.0, y: -self.frame.height / 2)
                self.firstFrame.frame = playerController.view.frame
            }
            
            if data == "~squareify"{ //weird shaped video
                playerController.view.frame.size = CGSize(width: self.frame.width * 0.55, height: self.frame.height * 2)
                playerController.view.frame.origin = CGPoint(x: (self.frame.width - playerController.view.frame.width) / 2.0, y: -self.frame.height / 2)
                self.firstFrame.frame = playerController.view.frame
            }
            
            if data == "~squareifyExport" { //weird shaped video
                playerController.view.frame.size = CGSize(width: self.frame.width * 0.68, height: self.frame.height * 2)
                playerController.view.frame.origin = CGPoint(x: (self.frame.width - playerController.view.frame.width) / 2.0, y: -self.frame.height / 2)
                self.firstFrame.frame = playerController.view.frame
            }

            
            
            playerController.player = AVPlayer(url: url)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            } catch _ {
            }
            self.player = playerController.player
            DispatchQueue.main.sync(execute: {
                self.videoContainer.addSubview(playerController.view)
            })
        })
        
    }
    
    @objc func videoToggeNotificationRecieved(_ notification: Notification) {
        if self.currentData == notification.object as? String {
            
            //restart if video is over
            if let length = player?.currentItem?.duration {
                let currentTime = player!.currentTime()
                if CMTimeGetSeconds(length) == CMTimeGetSeconds(currentTime) {
                    player!.seek(to: kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                    player!.play()
                    playing = true
                    playButton.isHidden = true
                    return
                }
            }
            
            playing = !playing
            if playing { player?.play() }
            else { player?.pause() }
            playButton.isHidden = playing
            firstFrame.isHidden = true
        }
    }
    
    @objc func pauseAllNotificationRecieved() {
        player?.pause()
        playButton.isHidden = false
        playing = false
    }
    
    @objc func videoEnded(_ notification: Notification) {

        if let playerItem = notification.object as? AVPlayerItem {
            let endedVideo = (playerItem.asset as! AVURLAsset).url.path
            
            if let thisAsset = self.player?.currentItem?.asset as? AVURLAsset {
                if thisAsset.url.path == endedVideo {
                    playing = false
                    playButton.isHidden = false
                }
            }
            
        }
        
    }
    
}
