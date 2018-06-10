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
    
    var appName : String?
    
    override func moduleType() -> ModuleType {
        return .app
    }
    
    override func displayWithData(_ data: String) {
        appName = data
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 15.0
        if appName == "inflation" {
            icon.image = UIImage(named: "inflationIcon")
        } else {
            background.image = UIImage(named: "square2")
        }
    }
    
    @IBAction func presentApp(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: LAUNCH_APP_DEMO), object: appName!)
    }
    
}
