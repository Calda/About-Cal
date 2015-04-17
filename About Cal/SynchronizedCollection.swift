//
//  SynchronizedCollection.swift
//  About Cal
//
//  Created by Cal on 4/17/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

let SYNCHRONIZED_COLLECTION_UPDATE_NOTIFICATION = "SYNCRONIZED_COLLECTION_UPDATE_NOTIFICATION"
let SYNCHRONIZED_COLLECTION_RESNAP_NOTIFICATION = "SYNCRONIZED_COLLECTION_RESNAP_NOTIFICATION"

class SynchronizedCollection : UICollectionViewController, UIGestureRecognizerDelegate {
    
    var speedProportion : CGFloat = 1.0
    var totalCollectionWidth : CGFloat = 1.0
    var recognizer : UIGestureRecognizer?
    var savedSyncRatio : CGFloat = 1.0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationRecieved:", name: SYNCHRONIZED_COLLECTION_UPDATE_NOTIFICATION, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resnapNotificationRecieved:", name: SYNCHRONIZED_COLLECTION_RESNAP_NOTIFICATION, object: nil)
    }
    
    func updateNotificationRecieved(notification: NSNotification) {
        if let sender = notification.object as? SynchronizedCollection {
            if sender == self { return }
            let ratio = self.totalCollectionWidth / sender.totalCollectionWidth
            savedSyncRatio = ratio
            let offset = CGPointMake(ratio * sender.collectionView!.contentOffset.x, 0)
            self.collectionView!.setContentOffset(offset, animated: false)
        }
    }
    
    func resnapNotificationRecieved(notification: NSNotification) {
        if let sender = notification.object as? CellPagingLayout {
            if sender == self.collectionView!.collectionViewLayout { return }
            let syncTarget = sender.mostRecentOffsetTarget
            let offset = CGPointMake(savedSyncRatio * syncTarget, 0)
            self.collectionView!.setContentOffset(offset, animated: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.collectionView?.reloadData()
        totalCollectionWidth = totalCollectionWidth(self.collectionView!)
        
        recognizer = UIPanGestureRecognizer(target: self, action: "touchRecieved")
        recognizer!.delegate = self
        self.collectionView!.addGestureRecognizer(recognizer!)
        
        self.collectionView!.decelerationRate = UIScrollViewDecelerationRateFast / 3
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func touchRecieved() { }
    
    func totalCollectionWidth(collection: UICollectionView) -> CGFloat {
        let count = collection.numberOfItemsInSection(0)
        let delegate = collection.delegate! as! UICollectionViewDelegateFlowLayout
        let zeroPath = NSIndexPath(forItem: 0, inSection: 0)
        let width = delegate.collectionView!(collection, layout: collection.collectionViewLayout, sizeForItemAtIndexPath: zeroPath).width
        let spacing = delegate.collectionView?(collection, layout: collection.collectionViewLayout, minimumLineSpacingForSectionAtIndex: 0)
        
        var totalWidth = CGFloat(count) * width
        if let spacing = spacing {
            totalWidth += CGFloat(count) * spacing
        }
        return totalWidth
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let recognizer = recognizer {
            let state = recognizer.state
            if recognizer.state != .Began && recognizer.state != .Changed && recognizer.state != .Ended {
                return
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName(SYNCHRONIZED_COLLECTION_UPDATE_NOTIFICATION, object: self)
    }
    
}
