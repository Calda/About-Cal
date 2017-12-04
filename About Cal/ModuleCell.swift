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
    case Title, Text, Image, Images, Video, App, WebText
    
    static func enumFromString(name: String) -> ModuleType {
        if name.hasPrefix("video"){ return .Video }
        switch(name.lowercaseString) {
            case "title": return .Title
            case "image": return .Image
            case "images": return .Images
            case "app": return .App
            case "webtext": return .WebText
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
            case .App: return "App"
            case .WebText: return "WebText"
        }
    }
    
    func heightForData(data: String, width: CGFloat) -> CGFloat {
        if self == .Text || self == .WebText{
            let attributes = TextCell.getContentTextAttributes()
            let context = NSStringDrawingContext()
            let labelSize = CGSizeMake(width - 20, CGFloat.max)
            
            let drawnSize = (data as NSString).boundingRectWithSize(labelSize, options: .UsesLineFragmentOrigin, attributes: attributes, context: context)
            return drawnSize.height * 1.05
        }
        
        if self == .Image {
            let splits = data.characters.split{ $0 == "/" }.map { String($0) }
            if splits.count != 2 { return 0 }
            return CGFloat(Int(splits[1])!)
        }
        
        if self == .Video {
            //I probably should have done this dynamically but I got lazy. Oops.
            if data == "molio" { return width * 372/640 }
            if data == "~squareifyExample" { return (width * (9/16)) * 1.5 }
            if data == "~instagramExample" { return (width * (9/16)) * 1.37 }
            if data == "~squareifyExport" { return (width * (9/16)) * 1.2 }
            if data == "~squareify" { return (width * (9/16)) * 1.75 }
            return width * (9/16)
        }
        
        if self == .App {
            return (150)
        }
        
        return 0
    }
    
}
