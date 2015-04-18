//
//  Globals.swift
//  About Cal
//
//  Created by Cal on 4/17/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

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


func delay(delay:Double, closure:()->()) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), closure)
}
