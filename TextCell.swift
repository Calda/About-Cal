//
//  ModuleCellTypes.swift
//  About Cal
//
//  Created by Cal on 4/18/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class TextCell : ModuleCell {
    
    @IBOutlet weak var content: UILabel!
    
    override func moduleType() -> ModuleType {
        return .Text
    }
    
    override func displayWithData(data: String) {
        let attributes = TextCell.getContentTextAttributes()
        content.attributedText = NSMutableAttributedString(string: data, attributes: attributes)
    }
    
    
    static func getContentTextAttributes() -> [String: AnyObject] {
        
        let font = UIFont(name: "HelveticaNeue-Thin", size: 19.0)!
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5.0
        style.firstLineHeadIndent = 40.0
        
        return [NSFontAttributeName : font, NSParagraphStyleAttributeName : style]
        
    }
    
}