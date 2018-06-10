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
    
    func decorateCell(_ collectionView: UICollectionView, icon: UIImage, color: UIColor, nextColor: UIColor?, drawArrow: Bool) {
        iconImage.image = icon
        iconImage.layer.cornerRadius = iconImage.frame.width / 2
        iconImage.clipsToBounds = true
        iconBorder.layer.cornerRadius = iconBorder.frame.width / 2
        iconBorder.layer.borderColor = color.cgColor
        iconBorder.layer.borderWidth = 2.5
        
        if let nextColor = nextColor {
            //create and draw gradient if there is a next color
            let iconFrame = self.frame
//            let iconCenter = CGPoint(x: iconFrame.midX, y: iconFrame.midY)
            
            let nextGradient = CAGradientLayer()
            nextGradient.frame = CGRect(x: iconFrame.midX + iconBorder.bounds.width/2 - 2, y: iconFrame.midY - 1.25, width: 72, height: 2.5)
            nextGradient.colors = [color.cgColor, nextColor.cgColor]
            nextGradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            nextGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            
            if drawArrow { //draw arrows
                let arrowLegWidth = nextGradient.frame.width / 4
                let arrowLegHeight = nextGradient.frame.height
                let arrowLegX = nextGradient.frame.midX
                let arrowLegY = nextGradient.frame.minY
                let root2Over4 = CGFloat(sqrt(2)/4.0)
                
                let topLegTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4.0))
                let bottomLegTransform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 4.0))
                
                let topLeg = CAGradientLayer()
                topLeg.frame = CGRect(x: arrowLegX - 0.9, y: arrowLegY - arrowLegWidth*root2Over4 + 0.9, width: arrowLegWidth, height: arrowLegHeight)
                topLeg.colors = nextGradient.colors
                topLeg.startPoint = CGPoint(x: 0.0, y: 0.5)
                topLeg.endPoint = CGPoint(x: 2.0, y: 0.5)
                topLeg.setAffineTransform(topLegTransform)
                collectionView.layer.addSublayer(topLeg)
                
                let bottomLeg = CAGradientLayer()
                bottomLeg.frame = CGRect(x: arrowLegX - 0.9, y: arrowLegY + arrowLegWidth*root2Over4 - 0.9, width: arrowLegWidth, height: arrowLegHeight)
                bottomLeg.colors = nextGradient.colors
                bottomLeg.startPoint = CGPoint(x: 0.0, y: 0.5)
                bottomLeg.endPoint = CGPoint(x: 2.0, y: 0.5)
                bottomLeg.setAffineTransform(bottomLegTransform)
                collectionView.layer.addSublayer(bottomLeg)
                
                //shorted gradient line
                nextGradient.frame.size = CGSize(width: nextGradient.frame.width * 0.69, height: nextGradient.frame.height)
                nextGradient.endPoint = CGPoint(x: 1.45, y: 0.5)
            }
            
            collectionView.layer.addSublayer(nextGradient)
            
        }
    }
    
}
