//
//  IconCollectionSource.swift
//  About Cal
//
//  Created by Cal on 4/15/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

let CONNECT_STATUS_BAR_VIEW = "CONNECT_STATUS_BAR_VIEW"

class IconCollectionView : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var colors: [UIColor] = []
    var viewIsReady = false
    var parsedPages : [PageData] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.collectionViewLayout = CellPagingLayout(pageWidth: 170)
        self.collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        self.collectionView?.reloadData()
        self.viewIsReady = true
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("sectionIcon", forIndexPath: indexPath) as! IconCell
        let color = colors[indexPath.item]
        var nextColor : UIColor?
        if indexPath.item + 1 < colors.count {
            nextColor = colors[indexPath.item + 1]
        }
        let icon = parsedPages[indexPath.item].icon
        cell.decorateCell(collectionView, icon: icon, color: color, nextColor: nextColor)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parsedPages.count
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
    
    func calculateColors() {
        let count = collectionView(self.collectionView!, numberOfItemsInSection: 0)
        for i in 0..<count {
            colors.append(UIColor(hue: (0.999/CGFloat(count)) * CGFloat(i) + 0.001, saturation: 0.5, brightness: 0.7, alpha: 1.0))
        }
    }
    
}