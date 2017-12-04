//
//  ModuleCellTypes.swift
//  About Cal
//
//  Created by Cal on 4/18/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class TitleCell : ModuleCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func moduleType() -> ModuleType {
        return .Title
    }
    
    func displayWithTitle(title: String, date: String?) {
        let titleAttributes : [String: AnyObject] = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Thin", size: 40.0)!]
        let attributedTitle = NSMutableAttributedString(string: title, attributes: titleAttributes)
        
        let newLabelText = attributedTitle
        
        if let date = date { //has date
            let dateAttributes : [String: AnyObject] = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Thin", size: 25.0)!]
            let attributedDate = NSMutableAttributedString(string: ("                                                " + date), attributes: dateAttributes)
            newLabelText.appendAttributedString(attributedDate)
        }
        
        label.attributedText = newLabelText
    }
    
}