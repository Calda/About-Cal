//
//  ViewController.swift
//  About Cal
//
//  Created by Cal on 4/14/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var textWidth: NSLayoutConstraint!
    //collection view of section icons
    @IBOutlet weak var sectionIcons: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set proper width for text fields
        textWidth.constant = self.view.bounds.width - 30
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("sectionIcon", forIndexPath: indexPath) as! IconCell
        cell.decorateCell(70, collectionView)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == 0 ? 10 : 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: self.view.frame.width/2 - 55, bottom: 0, right: self.view.frame.width/2 - 55)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 70
    }
    
}

