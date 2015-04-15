//
//  IconCell.swift
//  About Cal
//
//  Created by DFA Film 9: K-9 on 4/15/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class IconCell : UICollectionViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconBorder: UIImageView!
    
    func decorateCell(cellDistance: CGFloat, _ collectionView: UICollectionView) {
        iconImage.layer.cornerRadius = iconImage.frame.width / 2
        iconImage.clipsToBounds = true
        iconBorder.layer.cornerRadius = iconBorder.frame.width / 2
        let borderColor = UIColor(red: 68/255, green: 103/255, blue: 123/255, alpha: 1.0).CGColor
        iconBorder.layer.borderColor = borderColor
        iconBorder.layer.borderWidth = 2.5
        
        //create and draw gradient
        let iconFrame = self.frame
        let iconCenter = CGPointMake(CGRectGetMidX(iconFrame), CGRectGetMidY(iconFrame))
        let nextColor = UIColor(red: 123/255, green: 68/255, blue: 123/255, alpha: 1.0).CGColor
        
        let nextGradient = CAGradientLayer()
        nextGradient.frame = CGRectMake(CGRectGetMidX(iconFrame) + iconBorder.bounds.width/2 - 2, CGRectGetMidY(iconFrame) - 1.25, cellDistance, 2.5)
        nextGradient.colors = [borderColor, nextColor]
        nextGradient.startPoint = CGPointMake(0.0, 0.5)
        nextGradient.endPoint = CGPointMake(1.0, 0.5)
        collectionView.layer.insertSublayer(nextGradient, atIndex:0)
    }
    
}