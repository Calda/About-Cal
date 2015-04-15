//
//  ViewController.swift
//  About Cal
//
//  Created by Cal on 4/14/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconBorder: UIImageView!
    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var textWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create rounded mask and add border
        iconImage.layer.cornerRadius = iconImage.frame.width / 2
        iconImage.clipsToBounds = true
        iconBorder.layer.cornerRadius = iconBorder.frame.width / 2
        let borderColor = UIColor(red: 68/255, green: 103/255, blue: 123/255, alpha: 1.0).CGColor
        iconBorder.layer.borderColor = borderColor
        iconBorder.layer.borderWidth = 2.5
        
        //create and draw gradient
        let iconFrame = iconView.frame
        let iconCenter = CGPointMake(CGRectGetMidX(iconFrame), CGRectGetMidY(iconFrame))
        let pageWidth = self.view.frame.width
        let nextColor = UIColor(red: 123/255, green: 68/255, blue: 123/255, alpha: 1.0).CGColor
        
        let nextGradient = CAGradientLayer()
        nextGradient.frame = CGRectMake(CGRectGetMidX(iconFrame) + iconBorder.bounds.width/2 - 2, CGRectGetMidY(iconFrame) - 1.25, pageWidth, 2.5)
        nextGradient.colors = [borderColor, nextColor] as NSArray
        nextGradient.startPoint = CGPointMake(0.0, 0.5)
        nextGradient.endPoint = CGPointMake(1.0, 0.5)
        self.view.layer.insertSublayer(nextGradient, below: iconBorder.layer)
        
        //set proper width for text fields
        textWidth.constant = self.view.bounds.width - 30
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

