//
//  TableViewCell.swift
//  Restaurant
//
//  Created by Bora and Viren on 4/28/16.
//  Copyright © 2016 AOWare. All rights reserved.
//

import UIKit

private let width = CGFloat(1.4)
private let cornerRadius = CGFloat(33)

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressView: UITextView!
    
    @IBOutlet weak var ratingImage: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = cornerRadius
        mainView.layer.masksToBounds = true
        
        setBorder(mainView)
        
        mainView.sendSubviewToBack(restaurantImage)
        
        setBorder(addressView)
        
        setBorder(nameLabel)
        
        addressView.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
        
        setBorder(ratingImage)
        
        setShadow(shadowView)
        
        shadowView.layer.cornerRadius = cornerRadius
    }
    
    deinit {
        addressView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func setBorder(view: UIView) {
        view.layer.borderWidth = width
        view.layer.borderColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeZero
        view.layer.shadowRadius = 10
    }
    
    func setShadow(view: UIView) {
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 6
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        var topCorrect = (addressView.bounds.size.height - addressView.contentSize.height * addressView.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        addressView.contentInset.top = topCorrect
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
