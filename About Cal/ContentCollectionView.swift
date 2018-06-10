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

class ContentCollectionView : UICollectionViewController, WKNavigationDelegate , UICollectionViewDelegateFlowLayout {
    
    var iconCollection : UICollectionView?
    var parsedPages : [PageData] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        NotificationCenter.default.addObserver(self, selector: #selector(ContentCollectionView.launchApp(_:)), name: NSNotification.Name(rawValue: LAUNCH_APP_DEMO), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView!.collectionViewLayout = CellPagingLayout(pageWidth: collectionView!.frame.width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentPage", for: indexPath) as! ContentCell
        cell.buildContentFromPageData(parsedPages[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parsedPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.frame.size
    }
    
    @IBAction func videoPlayToggled(_ sender: UITapGestureRecognizer) {
        if let videoCell = sender.view as? VideoCell {
            let data = videoCell.currentData
            NotificationCenter.default.post(name: Notification.Name(rawValue: VIDEO_PLAY_TOGGLE_NOTIFICATION), object: data)
        }
    }
    
    // MARK: - embedded app controller
    
    @objc func launchApp(_ notification: Notification) {
        if let name = notification.object as? String {
            if name == "orbit" {
                _ = presentWithNavigation(OrbitViewController(), title: "Tap and Drag to spawn planets")
            }
            else if name == "inflation" {
                let storyboard = UIStoryboard(name: "Inflation", bundle: Bundle.main)
                let inflationController = storyboard.instantiateViewController(withIdentifier: "Inflation") 
               _ = presentWithNavigation(inflationController, title: nil)
            }
        }
    }
    
    func presentWithNavigation(_ viewController: UIViewController, title: String?) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        let back = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(ContentCollectionView.closeModalView(_:)))
        viewController.navigationItem.leftBarButtonItem = back
        if title != nil {
            viewController.navigationItem.title = title
        }
        self.present(nav, animated: true, completion: nil)
        return nav
    }
    
    @objc func closeModalView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - web controller
    
    var webController : UIViewController?
    var webView : WKWebView?
    var webDepth = -1
    
    @IBAction func openWebView(_ sender: UITapGestureRecognizer) {
//        let cell = sender.view as! WebTextCell
        webController = UIViewController()
        webView = WKWebView(frame: webController!.view.frame)
        webDepth = -1
        let request = URLRequest(url: URL(string: "http://www.hearatale.com/children.php")!)
        webView!.navigationDelegate = self
        webView!.load(request)
        webController!.view.addSubview(webView!)
        _ = presentWithNavigation(webController!, title: "Loading...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webController?.navigationItem.title = "Hear a Tale"
        webDepth += 1
        if webDepth >= 1 {
            webController!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(ContentCollectionView.webGoBack))
        }
    }
    
    @objc func webGoBack() {
        webView?.goBack()
        webDepth -= 2
        if webDepth < 1 {
            webController!.navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK: - scroll view
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView!.collectionViewLayout as! CellPagingLayout
        layout.enabled = true
    }
}
