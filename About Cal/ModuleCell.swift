//
//  ModuleCell.swift
//  About Cal
//
//  Created by Cal on 4/18/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ModuleCell : UICollectionViewCell {
    
    func moduleType() -> ModuleType {
        fatalError("must be overridden by subclass")
    }
    
    func displayWithData(data: String) {
        fatalError("must be overriden by subclass")
    }
    
}

enum ModuleType{
    case Title, Text, Image, Images, Video
    
    static func enumFromString(name: String) -> ModuleType {
        switch(name.lowercaseString) {
            case "title": return .Title
            case "image": return .Image
            case "images": return .Images
            case "video": return .Video
            default: return .Text
        }
    }
    
    func stringName() -> String {
        switch(self) {
            case .Title: return "Title"
            case .Text: return "Text"
            case .Image: return "Image"
            case .Images: return "Images"
            case .Video: return "Video"
        }
    }
    
    func heightForData(data: String, width: CGFloat) -> CGFloat {
        if self == .Text {
            let attributes = TextCell.getContentTextAttributes()
            let context = NSStringDrawingContext()
            let labelSize = CGSizeMake(width - 20, CGFloat.max)
            
            let drawnSize = (data as NSString).boundingRectWithSize(labelSize, options: .UsesLineFragmentOrigin, attributes: attributes, context: context)
            return drawnSize.height * 1.05
        }
        
        if self == .Image || self == .Images {
            return 300
        }
        return 0
    }
    
}
