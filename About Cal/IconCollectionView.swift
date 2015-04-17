//
//  IconCollectionSource.swift
//  About Cal
//
//  Created by Cal on 4/15/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

let CS_ICON_SETUP_NOTIFICATION = "CS_ICON_SETUP_NOTIFICATION"

class IconCollectionView : SynchronizedCollection, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var colors: [UIColor] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0...9 {
            colors.append(UIColor(hue: 0.1 * CGFloat(i), saturation: 0.5, brightness: 0.7, alpha: 1.0))
        }
        collectionView?.collectionViewLayout = CellPagingLayout(manualCenterAdjust: 33)
        self.collectionView?.reloadData()
    }

    override func setupNotificationName() -> String {
        return CS_ICON_SETUP_NOTIFICATION
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("sectionIcon", forIndexPath: indexPath) as! IconCell
        let color = colors[indexPath.item]
        var nextColor : UIColor?
        if indexPath.item + 1 < colors.count {
            nextColor = colors[indexPath.item + 1]
        }
        cell.decorateCell(collectionView, color: color, nextColor: nextColor)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == 0 ? colors.count : 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: self.view.frame.width/2 - 50, bottom: 0, right: self.view.frame.width/2 - 50)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 70
    }
    
    
}