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
    
    func decorateCell(collectionView: UICollectionView, icon: UIImage, color: UIColor, nextColor: UIColor?, drawArrow: Bool) {
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
            
            if drawArrow { //draw arrows
                let arrowLegWidth = nextGradient.frame.width / 4
                let arrowLegHeight = nextGradient.frame.height
                let arrowLegX = CGRectGetMidX(nextGradient.frame)
                let arrowLegY = CGRectGetMinY(nextGradient.frame)
                let root2Over4 = CGFloat(sqrt(2)/4.0)
                
                let topLegTransform = CGAffineTransformMakeRotation(CGFloat(M_PI / 4.0))
                let bottomLegTransform = CGAffineTransformMakeRotation(CGFloat(-M_PI / 4.0))
                
                let topLeg = CAGradientLayer()
                topLeg.frame = CGRectMake(arrowLegX - 0.9, arrowLegY - arrowLegWidth*root2Over4 + 0.9, arrowLegWidth, arrowLegHeight)
                topLeg.colors = nextGradient.colors
                topLeg.startPoint = CGPointMake(0.0, 0.5)
                topLeg.endPoint = CGPointMake(2.0, 0.5)
                topLeg.setAffineTransform(topLegTransform)
                collectionView.layer.addSublayer(topLeg)
                
                let bottomLeg = CAGradientLayer()
                bottomLeg.frame = CGRectMake(arrowLegX - 0.9, arrowLegY + arrowLegWidth*root2Over4 - 0.9, arrowLegWidth, arrowLegHeight)
                bottomLeg.colors = nextGradient.colors
                bottomLeg.startPoint = CGPointMake(0.0, 0.5)
                bottomLeg.endPoint = CGPointMake(2.0, 0.5)
                bottomLeg.setAffineTransform(bottomLegTransform)
                collectionView.layer.addSublayer(bottomLeg)
                
                //shorted gradient line
                nextGradient.frame.size = CGSizeMake(nextGradient.frame.width * 0.69, nextGradient.frame.height)
                nextGradient.endPoint = CGPointMake(1.45, 0.5)
            }
            
            collectionView.layer.addSublayer(nextGradient)
            
        }
    }
    
}