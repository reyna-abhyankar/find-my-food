//
//  AppDelegate.swift
//  Restaurant
//
//  Created by Bora and Viren on 4/20/16.
//  Copyright © 2016 AOWare. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        return true
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        let handledShortcutItem = self.handleShortcut(shortcutItem)
        completionHandler(handledShortcutItem)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.window?.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    enum ShortcutID: String {
        case results
        case cuisine
        
        init?(fullType: String) {
            guard let last = fullType.componentsSeparatedByString(".").last else {return nil}
            self.init(rawValue: last)
        }
        
        var type: String {
            return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        
        guard ShortcutID(fullType: shortcutItem.type) != nil else {return false}
        guard let shortcutType = shortcutItem.type as String? else {return false}
        
        switch shortcutType {
        case ShortcutID.cuisine.type:
            handled = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navVC = storyboard.instantiateViewControllerWithIdentifier("cuisineViewController") as! UINavigationController
            let cuisineVC = navVC.topViewController as! CuisineViewController
            let shakeVC = (self.window?.rootViewController as! UINavigationController).topViewController as! ShakeViewController
            cuisineVC.cuisineDelegate = shakeVC
            self.window?.rootViewController?.presentViewController(navVC, animated: true, completion: nil)
            break
        default:
            break
        }
        
        return handled
    }
}

