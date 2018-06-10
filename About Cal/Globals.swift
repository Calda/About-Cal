//
//  Globals.swift
//  About Cal
//
//  Created by Cal on 4/17/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

func totalCollectionWidth(_ collection: UICollectionView) -> CGFloat {
    let count = collection.numberOfItems(inSection: 0)
    let delegate = collection.delegate! as! UICollectionViewDelegateFlowLayout
    let zeroPath = IndexPath(item: 0, section: 0)
    let width = delegate.collectionView!(collection, layout: collection.collectionViewLayout, sizeForItemAt: zeroPath).width
    let spacing = delegate.collectionView?(collection, layout: collection.collectionViewLayout, minimumLineSpacingForSectionAt: 0)
    
    var totalWidth = CGFloat(count) * width
    if let spacing = spacing {
        totalWidth += CGFloat(count) * spacing
    }
    return totalWidth
}


func delay(_ delay:Double, closure:@escaping ()->()) {
    let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time, execute: closure)
}
