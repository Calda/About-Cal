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
let BACKGROUND_QUEUE = dispatch_queue_create("Background serial queue", DISPATCH_QUEUE_SERIAL)

class VideoCell : ModuleCell {
    
    @IBOutlet weak var playButton: UIImageView!
    @IBOutlet weak var firstFrame: UIImageView!
    
    @IBOutlet weak var videoContainer: UIView!
    var playing = false
    var player : AVPlayer?
    var currentData : String?
    
    override func moduleType() -> ModuleType {
        return .Video
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoToggeNotificationRecieved:", name: VIDEO_PLAY_TOGGLE_NOTIFICATION, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "pauseAllNotificationRecieved", name: PAUSE_ALL_NOTIFICATION, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoEnded:", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    override func displayWithData(data: String) {
        if data != "molio" { //molio is the exception to everything
            if currentData == data { return }
            currentData = data
        }
        
        var videoName : String = data
        
        if data.hasPrefix("~") {
            playButton.image = UIImage(named: "playButtonWhite")
            videoName = data.substringFromIndex(videoName.startIndex.successor())
        }
        playButton.hidden = false
        playing = false
        player?.pause()
        
        let path = NSBundle.mainBundle().pathForResource(videoName, ofType: "mov")!
        let url = NSURL(fileURLWithPath: path)
        firstFrame.image = UIImage(named: "\(videoName)-frame1")!
        firstFrame.hidden = false
        
        dispatch_async(BACKGROUND_QUEUE, {
            for subview in self.videoContainer.subviews {
                subview.removeFromSuperview()
            }
            let playerController = AVPlayerViewController()
            playerController.view.frame.size = CGSizeMake(self.frame.width, self.frame.height * 2)
            playerController.view.frame.origin = CGPointMake(0, -self.frame.height / 2)
            
            
            //I probably should have done this dynamically but I got lazy. Oops.
            
            if data == "~squareifyExample"{ //weird shaped video
                playerController.view.frame.size = CGSizeMake(self.frame.width * 0.51, self.frame.height * 2)
                playerController.view.frame.origin = CGPointMake((self.frame.width - playerController.view.frame.width) / 2.0, -self.frame.height / 2)
                self.firstFrame.frame = playerController.view.frame
            }
            
            if data == "~instagramExample" { //weird shaped video
                playerController.view.frame.size = CGSizeMake(self.frame.width * 0.6, self.frame.height * 2)
                playerController.view.frame.origin = CGPointMake((self.frame.width - playerController.view.frame.width) / 2.0, -self.frame.height / 2)
                self.firstFrame.frame = playerController.view.frame
            }
            
            if data == "~squareify"{ //weird shaped video
                playerController.view.frame.size = CGSizeMake(self.frame.width * 0.55, self.frame.height * 2)
                playerController.view.frame.origin = CGPointMake((self.frame.width - playerController.view.frame.width) / 2.0, -self.frame.height / 2)
                self.firstFrame.frame = playerController.view.frame
            }
            
            if data == "~squareifyExport" { //weird shaped video
                playerController.view.frame.size = CGSizeMake(self.frame.width * 0.68, self.frame.height * 2)
                playerController.view.frame.origin = CGPointMake((self.frame.width - playerController.view.frame.width) / 2.0, -self.frame.height / 2)
                self.firstFrame.frame = playerController.view.frame
            }

            
            
            playerController.player = AVPlayer(URL: url)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            } catch _ {
            }
            self.player = playerController.player
            dispatch_sync(dispatch_get_main_queue(), {
                self.videoContainer.addSubview(playerController.view)
            })
        })
        
    }
    
    func videoToggeNotificationRecieved(notification: NSNotification) {
        if self.currentData == notification.object as? String {
            
            //restart if video is over
            if let length = player?.currentItem?.duration {
                let currentTime = player!.currentTime()
                if CMTimeGetSeconds(length) == CMTimeGetSeconds(currentTime) {
                    player!.seekToTime(kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                    player!.play()
                    playing = true
                    playButton.hidden = true
                    return
                }
            }
            
            playing = !playing
            if playing { player?.play() }
            else { player?.pause() }
            playButton.hidden = playing
            firstFrame.hidden = true
        }
    }
    
    func pauseAllNotificationRecieved() {
        player?.pause()
        playButton.hidden = false
        playing = false
    }
    
    func videoEnded(notification: NSNotification) {

        if let playerItem = notification.object as? AVPlayerItem {
            let endedVideo = (playerItem.asset as! AVURLAsset).URL.path
            
            if let thisAsset = self.player?.currentItem?.asset as? AVURLAsset {
                if thisAsset.URL.path == endedVideo {
                    playing = false
                    playButton.hidden = false
                }
            }
            
        }
        
    }
    
}