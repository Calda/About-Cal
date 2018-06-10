//
//  IconCollectionSource.swift
//  About Cal
//
//  Created by Cal on 4/15/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

let CONNECT_STATUS_BAR_VIEW = "CONNECT_STATUS_BAR_VIEW"

class IconCollectionView : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var colors: [UIColor] = []
    var viewIsReady = false
    var parsedPages : [PageData] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.collectionViewLayout = CellPagingLayout(pageWidth: 170)
        self.collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        self.collectionView?.reloadData()
        self.viewIsReady = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionIcon", for: indexPath) as! IconCell
        let color = colors[indexPath.item]
        var nextColor : UIColor?
        if indexPath.item + 1 < colors.count {
            nextColor = colors[indexPath.item + 1]
        }
        let icon = parsedPages[indexPath.item].icon
        cell.decorateCell(collectionView, icon: icon, color: color, nextColor: nextColor, drawArrow: indexPath.item == 0)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parsedPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: self.view.frame.width/2 - 50, bottom: 0, right: self.view.frame.width/2 - 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 70
    }
    
    func calculateColors() {
        let count = collectionView(self.collectionView!, numberOfItemsInSection: 0)
        for i in 0..<count {
            colors.append(UIColor(hue: (0.999/CGFloat(count)) * CGFloat(i) + 0.001, saturation: 0.5, brightness: 0.7, alpha: 1.0))
        }
    }
    
}
