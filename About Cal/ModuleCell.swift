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
    
    func displayWithData(_ data: String) {
        fatalError("must be overriden by subclass")
    }
    
}

enum ModuleType{
    case title, text, image, images, video, app, webText
    
    static func enumFromString(_ name: String) -> ModuleType {
        if name.hasPrefix("video"){ return .video }
        switch(name.lowercased()) {
            case "title": return .title
            case "image": return .image
            case "images": return .images
            case "app": return .app
            case "webtext": return .webText
            default: return .text
        }
    }
    
    func stringName() -> String {
        switch(self) {
            case .title: return "Title"
            case .text: return "Text"
            case .image: return "Image"
            case .images: return "Images"
            case .video: return "Video"
            case .app: return "App"
            case .webText: return "WebText"
        }
    }
    
    func heightForData(_ data: String, width: CGFloat) -> CGFloat {
        if self == .text || self == .webText{
            let attributes = TextCell.getContentTextAttributes()
            let context = NSStringDrawingContext()
            let labelSize = CGSize(width: width - 20, height: CGFloat.greatestFiniteMagnitude)
            
            let drawnSize = (data as NSString).boundingRect(with: labelSize, options: .usesLineFragmentOrigin, attributes: attributes, context: context)
            return drawnSize.height * 1.05
        }
        
        if self == .image {
            let splits = data.split{ $0 == "/" }.map { String($0) }
            if splits.count != 2 { return 0 }
            return CGFloat(Int(splits[1])!)
        }
        
        if self == .video {
            //I probably should have done this dynamically but I got lazy. Oops.
            if data == "molio" { return width * 372/640 }
            if data == "~squareifyExample" { return (width * (9/16)) * 1.5 }
            if data == "~instagramExample" { return (width * (9/16)) * 1.37 }
            if data == "~squareifyExport" { return (width * (9/16)) * 1.2 }
            if data == "~squareify" { return (width * (9/16)) * 1.75 }
            return width * (9/16)
        }
        
        if self == .app {
            return (150)
        }
        
        return 0
    }
    
}
