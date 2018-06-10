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
        return .title
    }
    
    func displayWithTitle(_ title: String, date: String?) {
        let titleAttributes : [NSAttributedStringKey: Any] = [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Thin", size: 40.0)!]
        let attributedTitle = NSMutableAttributedString(string: title, attributes: titleAttributes)
        
        let newLabelText = attributedTitle
        
        if let date = date { //has date
            let dateAttributes : [NSAttributedStringKey: Any] = [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Thin", size: 25.0)!]
            let attributedDate = NSMutableAttributedString(string: ("                                                " + date), attributes: dateAttributes)
            newLabelText.append(attributedDate)
        }
        
        label.attributedText = newLabelText
    }
    
}
