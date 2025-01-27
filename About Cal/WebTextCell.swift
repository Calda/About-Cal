//
//  ModuleCellTypes.swift
//  About Cal
//
//  Created by Cal on 4/18/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class WebTextCell : ModuleCell {
    
    @IBOutlet weak var content: UILabel!
    var data : NSString?
    
    override func moduleType() -> ModuleType {
        return .text
    }
    
    override func displayWithData(_ data: String) {
        self.data = data as NSString
        let attributes = TextCell.getContentTextAttributes()
        let attributedText = NSMutableAttributedString(string: data, attributes: attributes)
        
        if (data as NSString).contains("http://") {
            //The website, Hear a Tale (http://hearatale.com)
            attributedText.addAttribute(NSAttributedStringKey.link, value: "http://www.hearatale.com", range: NSMakeRange(26, 20))
            
        }
        
        content.attributedText = attributedText
        
    }
    
    
    static func getContentTextAttributes() -> [String: AnyObject] {
        
        let font = UIFont(name: "HelveticaNeue-Thin", size: 19.0)!
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5.0
        style.firstLineHeadIndent = 20.0
        
        return [NSAttributedStringKey.font.rawValue : font, NSAttributedStringKey.paragraphStyle.rawValue : style]
        
    }
    
}
