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
    
    func decorateCell(collectionView: UICollectionView, icon: UIImage, color: UIColor, nextColor: UIColor?) {
        iconImage.image = icon
        iconImage.layer.cornerRadius = iconImage.frame.width / 2
        iconImage.clipsToBounds = true
        iconBorder.layer.cornerRadius = iconBorder.frame.width / 2
        iconBorder.layer.borderColor = color.CGColor
        iconBorder.layer.borderWidth = 2.5
        
        if let nextColor = nextColor {
            //create and draw gradient if there is a next color
            let iconFrame = self.frame
            let iconCenter = CGPointMake(CGRectGetMidX(iconFrame), CGRectGetMidY(iconFrame))
            
            let nextGradient = CAGradientLayer()
            nextGradient.frame = CGRectMake(CGRectGetMidX(iconFrame) + iconBorder.bounds.width/2 - 2, CGRectGetMidY(iconFrame) - 1.25, 72, 2.5)
            nextGradient.colors = [color.CGColor, nextColor.CGColor]
            nextGradient.startPoint = CGPointMake(0.0, 0.5)
            nextGradient.endPoint = CGPointMake(1.0, 0.5)
            collectionView.layer.addSublayer(nextGradient)
        }
    }
    
}