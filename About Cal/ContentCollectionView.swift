//
//  IconCollectionSource.swift
//  About Cal
//
//  Created by Cal on 4/15/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ContentCollectionView : SynchronizedCollection, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var iconCollection : UICollectionView?
    var parsedPages : [PageData] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.collectionViewLayout = CellPagingLayout(manualCenterAdjust: 0)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("contentPage", forIndexPath: indexPath) as! ContentCell
        cell.buildContentFromPageData(parsedPages[indexPath.item])
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parsedPages.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.frame.size
    }
    
    @IBAction func videoPlayToggled(sender: UITapGestureRecognizer) {
        if let videoCell = sender.view as? VideoCell {
            NSNotificationCenter.defaultCenter().postNotificationName(VIDEO_PLAY_TOGGLE_NOTIFICATION, object: videoCell)
        }
    }
    
}