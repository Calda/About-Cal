//
//  ModuleCellTypes.swift
//  About Cal
//
//  Created by Cal on 4/18/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ImageCell : ModuleCell {
    
    @IBOutlet weak var image: UIImageView!
    
    override func moduleType() -> ModuleType {
        return .image
    }
    
    override func displayWithData(_ data: String) {
        let splits = data.split{ $0 == "/" }.map { String($0) }
        
        image.image = UIImage(named: splits[0])
    }
    
}
