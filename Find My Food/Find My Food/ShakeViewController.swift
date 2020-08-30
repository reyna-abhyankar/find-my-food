//
//  ViewController.swift
//  Restaurant
//
//  Created by Bora and Viren on 4/20/16.
//  Copyright © 2016 AOWare. All rights reserved.
//

import UIKit
import CoreLocation

class ShakeViewController: UIViewController, CLLocationManagerDelegate, CuisineViewControllerDelegate {
    // MARK:- Variables and Constants
    
    let locationManager = CLLocationManager()
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var shakeLabel: UILabel!
    @IBOutlet weak var cuisineSelector: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cuisineSelection: String = "restaurants"
    var cuisineValuesDict: Dictionary<String, String> = [:]
    
    let apiConsoleInfo = YelpAPIConsole()
    let client = YelpAPIClient()
    
    var restaurantArray = [Restaurant]()
    
    // MARK:- API Call and Helper Methods
    
    func returnBusinessData(category: String) {
        self.restaurantArray.removeAll()
        client.searchPlacesWithParameters(["ll": "\(latitude),\(longitude)", "category_filter": category, "radius_filter": "12000", "sort": "0"], successSearch: { (data, response) -> Void in
            
            do {
                let results = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
                
                //print(results)
                
                let businesses = results["businesses"] as! NSArray
                var filteredBusinesses = [Dictionary<String, AnyObject>]()
                
                for business in businesses {
                    if ((business["rating"] as! Double) >= 3.0) {
                        filteredBusinesses.append(business as! Dictionary<String, AnyObject>)
                    }
                }
                
                let count = filteredBusinesses.count

                if count != 0 {
                    switch count {
                    case 1:
                        self.restaurantAppend(filteredBusinesses, value: 0)
                    case 2:
                        self.restaurantAppend(filteredBusinesses, value: 0)
                        self.restaurantAppend(filteredBusinesses, value: 1)
                    default:
                        let getRandom = self.randomSequenceGenerator(0, max: ((filteredBusinesses.count)-1))
                        for _ in 1...3 {
                            let value: Int = getRandom()
                            self.restaurantAppend(filteredBusinesses, value: value)
                        }
                    }
                    
                    self.performSegueWithIdentifier("resultsPush", sender: nil)
                    
                } else {
                    self.cuisineLabel.text = "No results found based on your search."
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }) { (error) -> Void in
            print(error)
        }
    }
    
    func restaurantAppend(array: Array<Dictionary<String, AnyObject>>, value: Int) {
        let dict = array[value]
        let restaurant = Restaurant(dictionary: dict)
        restaurantArray.append(restaurant)
    }
    
    func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
        var numbers: [Int] = []
        return {
            if numbers.count == 0 {
                numbers = Array(min ... max)
            }
            
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.removeAtIndex(index)
        }
    }
    
    // MARK:- Delegate Method
    
    func cuisineViewController(controller: CuisineViewController, didFinishWithSelectedCuisine cuisine: String) {
        cuisineSelection = cuisineValuesDict[cuisine]!
    }
    
    // MARK:- Location Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations)
        latitude = locationManager.location?.coordinate.latitude
        longitude = locationManager.location?.coordinate.longitude
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Error: " + error.localizedDescription)
    }
    
    // MARK:- Override Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "resultsPush" {
            let resultsVC = segue.destinationViewController as! ResultsViewController
            resultsVC.array = restaurantArray
        } else if segue.identifier == "cuisineModal" {
            let navVC = segue.destinationViewController as! UINavigationController
            let cuisineVC = navVC.topViewController as! CuisineViewController
            cuisineVC.cuisineDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let path = NSBundle.mainBundle().pathForResource("Cuisines", ofType: "plist")
        cuisineValuesDict = NSDictionary(contentsOfFile: path!) as! Dictionary<String, String>
        
        self.navigationController?.navigationBarHidden = true
        
        cuisineSelector.layer.cornerRadius = 6
        cuisineSelector.layer.zPosition = 1
        cuisineSelector.backgroundColor = UIColor(red:1.00, green:0.69, blue:0.00, alpha:1.0)
        cuisineSelector.layer.borderWidth = 0.5
        cuisineSelector.layer.borderColor = UIColor.whiteColor().CGColor
        
        cuisineLabel.text = ""
        
        topLabel.center.x -= view.bounds.width
        shakeLabel.center.x -= view.bounds.width
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.topLabel.center.x += self.view.bounds.width
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 1.0, options: .CurveEaseInOut, animations: {
            self.shakeLabel.center.x += self.view.bounds.width
            }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 1.5, options: .CurveEaseIn, animations: {
            self.shakeLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/6))
            
            UIView.animateWithDuration(1.0, delay: 2.5, options: .CurveLinear, animations: {
                self.shakeLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/6*(-1)))
                
                UIView.animateWithDuration(1.0, delay: 3.5, options: .CurveEaseOut, animations: {
                    self.shakeLabel.transform = CGAffineTransformMakeRotation(0)
                    }, completion: nil)
                }, completion: nil)
            
            }, completion: nil)

        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        super.becomeFirstResponder()
        becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        super.resignFirstResponder()
        resignFirstResponder()
        self.navigationController?.navigationBar.tintColor = UIColor.redColor()
        self.navigationController?.navigationBarHidden = false
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            activityIndicator.startAnimating()
            returnBusinessData(cuisineSelection)
            activityIndicator.stopAnimating()
        }
    }
}

