//
//  IconCollectionSource.swift
//  About Cal
//
//  Created by Cal on 4/15/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit
import WebKit
import CoreGraphics

class ContentCollectionView : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WKNavigationDelegate, UIScrollViewDelegate {
    
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
    
    // MARK: - embedded app controller
    
    func launchApp(notification: NSNotification) {
        if let name = notification.object as? String {
            if name == "orbit" {
                presentWithNavigation(OrbitViewController(), title: "Tap and Drag to spawn planets")
            }
            else if name == "inflation" {
                let storyboard = UIStoryboard(name: "Inflation", bundle: NSBundle.mainBundle())
                let inflationController = storyboard.instantiateViewControllerWithIdentifier("Inflation") as! UIViewController
               presentWithNavigation(inflationController, title: nil)
            }
        }
    }
    
    func presentWithNavigation(viewController: UIViewController, title: String?) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        let back = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "closeModalView:")
        viewController.navigationItem.leftBarButtonItem = back
        if title != nil {
            viewController.navigationItem.title = title
        }
        self.presentViewController(nav, animated: true, completion: nil)
        return nav
    }
    
    func closeModalView(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - web controller
    
    var webController : UIViewController?
    var webView : WKWebView?
    var webDepth = -1
    
    @IBAction func openWebView(sender: UITapGestureRecognizer) {
        let cell = sender.view as! WebTextCell
        webController = UIViewController()
        webView = WKWebView(frame: webController!.view.frame)
        webDepth = -1
        let request = NSURLRequest(URL: NSURL(string: "http://www.hearatale.com/children.php")!)
        webView!.navigationDelegate = self
        webView!.loadRequest(request)
        webController!.view.addSubview(webView!)
        presentWithNavigation(webController!, title: "Loading...")
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        webController?.navigationItem.title = "Hear a Tale"
        webDepth += 1
        if webDepth >= 1 {
            webController!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "< Back", style: .Plain, target: self, action: "webGoBack")
        }
    }
    
    func webGoBack() {
        webView?.goBack()
        webDepth -= 2
        if webDepth < 1 {
            webController!.navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK: - scroll view
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let layout = self.collectionView!.collectionViewLayout as! CellPagingLayout
        layout.enabled = true
    }
}