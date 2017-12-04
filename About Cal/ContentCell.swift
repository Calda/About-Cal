//
//  ContentCell.swift
//  About Cal
//
//  Created by Cal on 4/16/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ContentCell : UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var moduleCollection: UICollectionView!
    var pageData: PageData?
    
    func buildContentFromPageData(data: PageData) {
        self.moduleCollection.contentOffset = CGPoint(x: 0, y: 0)
        if pageData == nil || pageData!.title != data.title {
            self.pageData = data
            self.moduleCollection.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (pageData == nil ? 0 : pageData!.modules.count + 1)
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let pageData = pageData {
            
            if indexPath.item == 0 { //title view
                let titleModule = collectionView.dequeueReusableCellWithReuseIdentifier("title", forIndexPath: indexPath) as! TitleCell
                titleModule.displayWithTitle(pageData.title, date: pageData.date)
                return titleModule
            }
            
            let index = indexPath.item - 1
            let type = pageData.modules[index].type
            
            let module = collectionView.dequeueReusableCellWithReuseIdentifier(type, forIndexPath: indexPath) as? ModuleCell
            if let module = module {
                module.displayWithData(pageData.modules[index].data)
                return module
            }
        }
        return collectionView.dequeueReusableCellWithReuseIdentifier("blank", forIndexPath: indexPath) 
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let pageData = pageData {
            var height: CGFloat = 0
            
            if indexPath.item == 0 { //is first, thus is title, then needs special treatment
                height = 45.0
                if pageData.date != nil { height += 25.0 }
            }
            
            else { //doesn't get special treatment
                let module = pageData.modules[indexPath.item - 1]
                let moduleType = ModuleType.enumFromString(module.type)
                height = moduleType.heightForData(module.data, width: self.frame.width)
            }
            
            return CGSizeMake(self.frame.width, height)
        }
        
        return CGSizeZero
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right: 0)
    }
    
}
