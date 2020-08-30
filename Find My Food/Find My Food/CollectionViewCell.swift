//
//  CollectionViewCell.swift
//  Restaurant
//
//  Created by Bora and Viren on 4/22/16.
//  Copyright © 2016 AOWare. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cuisine: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        let imageLayer = imageView.layer
        
        imageLayer.cornerRadius = imageView.frame.height/2
        imageLayer.borderWidth = 3.0
        imageLayer.borderColor = UIColor.blackColor().CGColor
        
        imageLayer.masksToBounds = false
        imageView.clipsToBounds = true
        
        layer.cornerRadius = 30
        
        /*(UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()*/
    }
    
}
