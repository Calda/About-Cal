//
//  IconCollectionSource.swift
//  About Cal
//
//  Created by Cal on 4/15/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ContentCollectionView : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.collectionViewLayout = CellPagingLayout(manualCenterAdjust: 0)
        self.collectionView?.reloadData()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("contentPage", forIndexPath: indexPath) as! ContentCell
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.frame.size
    }
    
    
}