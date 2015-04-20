//
//  ModuleCellTypes.swift
//  About Cal
//
//  Created by Cal on 4/18/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

let LAUNCH_APP_DEMO = "LAUNCH_APP_DEMO"

class AppCell : ModuleCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var background: UIImageView!
    var appName = "orbit"
    
    override func moduleType() -> ModuleType {
        return .App
    }
    
    override func displayWithData(data: String) {
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 15.0
        //background.clipsToBounds = true
        //background.layer.cornerRadius = background.
    }
    
    @IBAction func presentApp(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(LAUNCH_APP_DEMO, object: appName)
    }
    
}