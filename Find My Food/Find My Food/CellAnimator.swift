//
//  CellAnimator.swift
//  Restaurant
//
//  Created by Bora and Viren on 5/1/16.
//  Copyright © 2016 AOWare. All rights reserved.
//

import Foundation

import UIKit
import QuartzCore

let CellAnimatorStartTransform:CATransform3D = {
    let rotationDegrees: CGFloat = 30.0
    let rotationRadians: CGFloat = rotationDegrees * (CGFloat(M_PI)/180.0)
    
    let offset = CGPointMake(-20, -20)
    
    var startTransform = CATransform3DIdentity
    startTransform = CATransform3DRotate(CATransform3DIdentity, rotationRadians, 0.0, 0.0, 1.0)
    
    startTransform = CATransform3DTranslate(startTransform, offset.x, offset.y, 0.0)
    
    return startTransform
}()

class CellAnimator {
    class func animateTableCell(cell:UITableViewCell) {
        let view = cell.contentView
        
        view.layer.transform = CellAnimatorStartTransform
        view.layer.opacity = 0.8
        
        UIView.animateWithDuration(0.4) {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        }
    }
}