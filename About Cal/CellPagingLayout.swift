//
//  CellPagingCollectionLayout.swift
//  About Cal
//
//  Created by Cal on 4/15/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class CellPagingLayout : UICollectionViewFlowLayout {
    
    var manualCenterAdjust : CGFloat = 0
    var mostRecentOffsetTarget : CGFloat = 0
    
    init(manualCenterAdjust: CGFloat) {
        super.init()
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.manualCenterAdjust = manualCenterAdjust
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var adjust = CGFloat.max
        var horizontalOffset = proposedContentOffset.x
        
        if horizontalOffset == 0 {
            mostRecentOffsetTarget = 0
            NSNotificationCenter.defaultCenter().postNotificationName(SYNCHRONIZED_COLLECTION_RESNAP_NOTIFICATION, object: self)
            return CGPointMake(0, 0)
        }
        
        let targetRect = CGRect(x: horizontalOffset, y: 0, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height)
        for attribute in self.layoutAttributesForElementsInRect(targetRect)! as! [UICollectionViewLayoutAttributes] {
            let itemOffset = attribute.frame.origin.x + manualCenterAdjust
            if abs(itemOffset - horizontalOffset) < abs(adjust) {
                adjust = itemOffset - horizontalOffset
            }
        }
        
        mostRecentOffsetTarget = horizontalOffset + adjust
        NSNotificationCenter.defaultCenter().postNotificationName(SYNCHRONIZED_COLLECTION_RESNAP_NOTIFICATION, object: self)
        return CGPointMake(mostRecentOffsetTarget, 0)
    }
    
    
    
}