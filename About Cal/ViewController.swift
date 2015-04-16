//
//  ViewController.swift
//  About Cal
//
//  Created by Cal on 4/14/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //collection view of section icons
    @IBOutlet weak var sectionIcons: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set proper width for text fields
        //textWidth.constant = self.view.bounds.width - 30
        //self.view.layoutIfNeeded()
        
        let sectionIconsDelegate = IconCollectionDelegate(screenWidth: self.view.frame.width)
        sectionIcons.delegate = sectionIconsDelegate
        sectionIcons.dataSource = sectionIconsDelegate
        sectionIcons.reloadData()
        println("test")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

