//
//  SynchronizedCollection.swift
//  About Cal
//
//  Created by Cal on 4/17/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class SynchronizedCollection : UICollectionViewController {
    
    var syncCollection : UICollectionView?
    var speedProportion : CGFloat = 1.0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUpNotificationRecieved:", name: setupNotificationName(), object: nil)
    }
    
    func setupNotificationName() -> String {
        fatalError("This must be overriden by a subclass.")
    }
    
    func setUpNotificationRecieved(notification: NSNotification) {
        if let syncCollection = notification.object as? UICollectionView {
            self.syncCollection = syncCollection
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.collectionView?.reloadData()
        updateSpeedProportion()
    }
    
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
    
    func updateSpeedProportion() {
        if let syncCollection = syncCollection {
            let thisWidth = totalCollectionWidth(self.collectionView!)
            let iconWidth = totalCollectionWidth(syncCollection)
            speedProportion = iconWidth / thisWidth
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //super.scrollViewDidScroll(scrollView)
        if let iconController = syncCollection {
            iconController.setContentOffset(CGPointMake(self.collectionView!.contentOffset.x * speedProportion, 0), animated: false)
        }
    }
    
    
}
