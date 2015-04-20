//
//  IconCollectionSource.swift
//  About Cal
//
//  Created by Cal on 4/15/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ContentCollectionView : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var iconCollection : UICollectionView?
    var parsedPages : [PageData] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "launchApp:", name: LAUNCH_APP_DEMO, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        collectionView!.collectionViewLayout = CellPagingLayout(pageWidth: collectionView!.frame.width)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("contentPage", forIndexPath: indexPath) as! ContentCell
        cell.buildContentFromPageData(parsedPages[indexPath.item])
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parsedPages.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.frame.size
    }
    
    @IBAction func videoPlayToggled(sender: UITapGestureRecognizer) {
        if let videoCell = sender.view as? VideoCell {
            let data = videoCell.currentData
            NSNotificationCenter.defaultCenter().postNotificationName(VIDEO_PLAY_TOGGLE_NOTIFICATION, object: data)
        }
    }

    var appController : UINavigationController?
    
    func launchApp(notification: NSNotification) {
        let viewController = OrbitViewController()
        let nav = UINavigationController(rootViewController: viewController)
        let back = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "closeModalView:")
        viewController.navigationItem.leftBarButtonItem = back
        viewController.navigationItem.title = "Tap and Drag to spawn planets"
        self.presentViewController(nav, animated: true, completion: nil)
        appController = nav
    }
    
    func closeModalView(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}