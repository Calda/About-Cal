//
//  ViewController.swift
//  About Cal
//
//  Created by Cal on 4/14/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var statusBarShadow: UIView!
    var iconCollection : IconCollectionView? = nil
    var parsedPages : [PageData] = []
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func syncShadowWithIconCollection() {
        
        func runAgain() {
            delay(0.05) {
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
            
            runAgain()
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedIcons" {
            iconCollection = segue.destinationViewController as? IconCollectionView
            syncShadowWithIconCollection()
            iconCollection?.parsedPages = parsedPages
            iconCollection?.calculateColors()
        }
        if segue.identifier == "embedContent" {
            let contentCollection = segue.destinationViewController as? ContentCollectionView
            contentCollection?.parsedPages = parsedPages
        }
    }
    
}
