//
//  ViewController.swift
//  About Cal
//
//  Created by Cal on 4/14/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var statusBarShadow: UIView!
    var iconCollection : IconCollectionView? = nil
    var contentCollection : ContentCollectionView? = nil
    var parsedPages : [PageData] = []

    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var contentContainer: UIView!
    
    var panningOnIcons = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let parser = ContentParser()
        parsedPages = parser.pages
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //design icon shadow
        statusBarShadow.layer.masksToBounds = false
        statusBarShadow.layer.shadowOffset = CGSizeMake(0, 150)
        statusBarShadow.layer.shadowRadius = 50
        statusBarShadow.layer.shadowOpacity = 0.2
        statusBarShadow.layer.shadowColor = UIColor(hue: 0.001, saturation: 0.5, brightness: 0.7, alpha: 1.0).CGColor
        
        let iconEnd = iconContainer.frame.origin
        let contentEnd = contentContainer.frame.origin
        
        let iconStart = CGPointMake(iconEnd.x, iconEnd.y - iconContainer.frame.height * 1.5)
        let contentStart = CGPointMake(contentEnd.x, contentEnd.y + contentContainer.frame.height * 1.2)
        
        iconContainer.frame.origin = iconStart
        contentContainer.frame.origin = contentStart
        
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: nil, animations: {
            self.iconContainer.frame.origin = iconEnd
            self.contentContainer.frame.origin = contentEnd
        }, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func syncShadowWithIconCollection() {
        
        func runAgain() {
            delay(0.0025) {
                self.syncShadowWithIconCollection()
            }
        }
        
        if let iconCollection  = iconCollection {
            //wait until itemCollection is loaded
            if !iconCollection.viewIsReady { runAgain(); return; }
            
            let shadowColor : UIColor
            //calculate needed color
            let percentage = iconCollection.collectionView!.contentOffset.x / totalCollectionWidth(iconCollection.collectionView!)
            let percentagePerColor = 1 / CGFloat(iconCollection.colors.count)
            let colorNumber = percentage / percentagePerColor
            
            if colorNumber <= 0.0{
                shadowColor = iconCollection.colors.first!
            }
            
            else if colorNumber >= CGFloat(iconCollection.colors.count - 1) {
                shadowColor = iconCollection.colors.last!
            }
                
            else {
                let colorIndex1 = Int(floor(colorNumber))
                let colorIndex2 = Int(ceil(colorNumber))
                let ratio = 1 - (CGFloat(colorIndex2) - colorNumber)
                
                var hue1 : CGFloat = 0.0
                var sat : CGFloat = 0.0
                var bright  : CGFloat = 0.0
                iconCollection.colors[colorIndex1].getHue(&hue1, saturation: &sat, brightness: &bright, alpha: nil)
                
                var hue2 : CGFloat = 0.0
                iconCollection.colors[colorIndex2].getHue(&hue2, saturation: nil, brightness: nil, alpha: nil)
                
                //DERIVED FORMULA:
                //new hue = hue1 - cx
                //c = hue1 - hue2, x = ratio
                
                let c = hue1 - hue2
                let newHue = hue1 - c * ratio
                shadowColor = UIColor(hue: newHue, saturation: sat, brightness: bright, alpha: 1.0)
            }
            
            statusBarShadow.layer.shadowColor = shadowColor.CGColor
            
            //also sync icons with content
            if panningOnIcons { //pan on icons
                sync(iconCollection.collectionView!, with: contentCollection!.collectionView!)
            }
            else { //pan on content
                sync(contentCollection!.collectionView!, with: iconCollection.collectionView!)
            }
            
            runAgain()
        }
        
    }
    
    func sync(a: UICollectionView, with b: UICollectionView) {
        let aPercentage = a.contentOffset.x / totalCollectionWidth(a)
        let newBOffset = totalCollectionWidth(b) * aPercentage
        b.contentOffset = CGPointMake(newBOffset, 0)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedIcons" {
            iconCollection = segue.destinationViewController as? IconCollectionView
            syncShadowWithIconCollection()
            iconCollection?.parsedPages = parsedPages
            iconCollection?.calculateColors()
        }
        if segue.identifier == "embedContent" {
            contentCollection = segue.destinationViewController as? ContentCollectionView
            contentCollection?.parsedPages = parsedPages
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func panStartListener(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            let panLocation = sender.locationInView(self.view)
            self.panningOnIcons = CGRectContainsPoint(iconContainer.frame, panLocation)
        }
    }
    
    
}
