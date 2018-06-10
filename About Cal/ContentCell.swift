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
    
    func buildContentFromPageData(_ data: PageData) {
        self.moduleCollection.contentOffset = CGPoint(x: 0, y: 0)
        if pageData == nil || pageData!.title != data.title {
            self.pageData = data
            self.moduleCollection.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (pageData == nil ? 0 : pageData!.modules.count + 1)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let pageData = pageData {
            
            if indexPath.item == 0 { //title view
                let titleModule = collectionView.dequeueReusableCell(withReuseIdentifier: "title", for: indexPath) as! TitleCell
                titleModule.displayWithTitle(pageData.title, date: pageData.date)
                return titleModule
            }
            
            let index = indexPath.item - 1
            let type = pageData.modules[index].type
            
            let module = collectionView.dequeueReusableCell(withReuseIdentifier: type, for: indexPath) as? ModuleCell
            if let module = module {
                module.displayWithData(pageData.modules[index].data)
                return module
            }
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "blank", for: indexPath) 
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
            
            return CGSize(width: self.frame.width, height: height)
        }
        
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right: 0)
    }
    
}
