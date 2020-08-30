//
//  BusinessModel.swift
//  
//
//  Created by Bora & Viren on 4/27/16.
//
//

import Foundation
import UIKit

class Restaurant: NSObject {
    var businessID: String!
    var businessName: String!
    var businessImageURL: NSString!
    var businessImage: UIImage!
    var businessRatingImage: UIImage!
    var businessLocationArray: Array<String>!
    var businessLocationDisplayAddress: String!

    convenience init(dictionary: Dictionary<String, AnyObject>) {
        self.init()
    
        businessID = dictionary["id"] as! String // Gets the ID of the restaurant
        businessName = dictionary["name"] as! String // Gets the name of the restaurant
        
        let oldString = dictionary["image_url"] as! NSString // Gets the URL of the image...
        businessImageURL = oldString.stringByReplacingOccurrencesOfString("ms.jpg", withString: "o.jpg") //...gets the URL for the HD image
        
        let data = NSData(contentsOfURL: NSURL(string: businessImageURL as String)!) // Gets the exact image based on the above URL
        businessImage = UIImage(data: data!)
        
        let imageData = NSData(contentsOfURL: NSURL(string: dictionary["rating_img_url_large"] as! String)!) // Gets the rating image (review stars)
        businessRatingImage = UIImage(data: imageData!)
        
        businessLocationArray = dictionary["location"]!["display_address"] as! Array // Gets the address (each line is a different object in an array)
        businessLocationDisplayAddress = businessLocationArray.joinWithSeparator("\n") // Turns all the items in the array into one string separated by a line break
    }
}