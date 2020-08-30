//
//  CuisineViewController.swift
//  Restaurant
//
//  Created by Bora and Viren on 4/22/16.
//  Copyright © 2016 AOWare. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cuisineCell"

protocol CuisineViewControllerDelegate: class {
    func cuisineViewController(controller: CuisineViewController, didFinishWithSelectedCuisine cuisine: String)
}

class CuisineViewController: UICollectionViewController {
    
    // MARK:- Variables and Constants

    var cuisines = []
    var dict = [:]
    
    var selectedCuisine = ""
    weak var cuisineDelegate: CuisineViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // Do any additional setup after loading the view.
        let path = NSBundle.mainBundle().pathForResource("Cuisines", ofType: "plist")
        dict = NSDictionary(contentsOfFile: path!)!
        cuisines = (dict.allKeys).sort {$0.localizedCaseInsensitiveCompare($1 as! String) == NSComparisonResult.OrderedAscending}
        
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // MARK:- Override Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.redColor()
    }
    
    // MARK:- IBAction Methods
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        if selectedCuisine != "" {
            cuisineDelegate?.cuisineViewController(self, didFinishWithSelectedCuisine: selectedCuisine)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK:- UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cuisines.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        
        cell.selected = false
        customConfigure(cell, forRowAtIndexPath: indexPath)
        
        return cell
    }
    
    var selectedIndexPath: NSIndexPath?
    
    func customConfigure(cell: CollectionViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let index = cuisines[indexPath.row] as? String
        cell.cuisine.text = index
        cell.imageView.image = UIImage(named: dict[index!] as! String)
        
        if selectedIndexPath == indexPath {
            // selected
            let color = UIColor(red: 0.8, green: 0.95, blue: 1.0, alpha: 1.0)
            cell.backgroundColor = color
        }
        else {
            // not selected
            cell.backgroundColor = UIColor.whiteColor()
        }
    }

    // MARK:- UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if selectedIndexPath == indexPath {
            // selected same cell -> deselect all
            selectedIndexPath = nil
        }
        else {
            // select different cell
            let oldSelectedIndexPath = selectedIndexPath
            selectedIndexPath = indexPath
            
            // refresh old cell to clear old selection indicators
            //let previousSelectedCell: CollectionViewCell?
            if let previousSelectedIndexPath = oldSelectedIndexPath {
                if let previousSelectedCell = collectionView.cellForItemAtIndexPath(previousSelectedIndexPath) as? CollectionViewCell {
                    customConfigure(previousSelectedCell, forRowAtIndexPath: previousSelectedIndexPath)
                }
                
            }
        }
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        customConfigure(selectedCell, forRowAtIndexPath: indexPath)
        
        selectedCuisine = selectedCell.cuisine.text!
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
