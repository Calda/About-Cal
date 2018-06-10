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
        return .text
    }
    
    override func displayWithData(_ data: String) {
        let attributes = TextCell.getContentTextAttributes()
        let attributedText = NSMutableAttributedString(string: data, attributes: attributes)
        
        content.attributedText = attributedText
        
    }

    
    static func getContentTextAttributes() -> [NSAttributedStringKey: Any] {
        
        let font = UIFont(name: "HelveticaNeue-Thin", size: 19.0)!
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5.0
        style.firstLineHeadIndent = 20.0
        
        return [NSAttributedStringKey.font : font, NSAttributedStringKey.paragraphStyle : style]
        
    }
    
}
