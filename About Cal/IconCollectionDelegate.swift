//
//  IconCollectionSource.swift
//  About Cal
//
//  Created by Cal on 4/15/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class IconCollectionDelegate : NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var colors: [UIColor] = []
    let screenWidth: CGFloat
    
    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth
        for i in 0...9 {
            colors.append(UIColor(hue: 1 - CGFloat(i) * 0.1, saturation: 0.4, brightness: 0.6, alpha: 1.0))
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("sectionIcon", forIndexPath: indexPath) as! IconCell
        let color = colors[indexPath.item]
        var nextColor : UIColor?
        if indexPath.item + 1 < colors.count {
            nextColor = colors[indexPath.item + 1]
        }
        cell.decorateCell(collectionView, color: color, nextColor: nextColor)
        return cell
    }
    
    //(section == 0 ? colors.count : 0)
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: screenWidth/2 - 50, bottom: 0, right: screenWidth/2 - 50)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 70
    }
    
    
}