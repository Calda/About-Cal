//
//  ViewController.swift
//  About Cal
//
//  Created by Cal on 4/14/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var iconCollection : UICollectionView?
    var contentCollection : UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set proper width for text fields
        //textWidth.constant = self.view.bounds.width - 30
        //self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedContent" {
            let contentController = segue.destinationViewController as! ContentCollectionView
            contentCollection = contentController.collectionView!
        }
        if segue.identifier == "embedIcons" {
            let iconController = segue.destinationViewController as! IconCollectionView
            iconCollection = iconController.collectionView!
        }
        
        if let iconCollection = iconCollection {
           NSNotificationCenter.defaultCenter().postNotificationName(CS_CONTENT_SETUP_NOTIFICATION, object: iconCollection)
        }
        if let contentCollection = contentCollection {
            NSNotificationCenter.defaultCenter().postNotificationName(CS_ICON_SETUP_NOTIFICATION, object: contentCollection)
        }
    }
    
}

