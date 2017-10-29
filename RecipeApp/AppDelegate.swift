//
//  AppDelegate.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/8/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import MobileCenter
import MobileCenterAnalytics
import MobileCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

	private let parseApplicationId = "recipe-id"
    private let parseServer = "cp-recipe.herokuapp.com/parse"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
        // Force all nav bar items to appear white
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
		Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) in
			configuration.applicationId = self.parseApplicationId
			configuration.server = "http://\(self.parseServer)"
			PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
		}))
		
		PFUser.register(FacebookAuthDelegate(), forAuthType: "facebook")

		let user = PFUser.current()
        if user != nil {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // For testing cookbook vc - remove when done
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "CookbookNavigationController")
//            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "HomeTabController")
		} else {
			// Override point for customization after application launch.
			let storyboard = UIStoryboard(name: "Login", bundle: nil)
			// view controller currently being set in Storyboard as default will be overridden
			window?.rootViewController = storyboard.instantiateInitialViewController()
		}
        
        MSMobileCenter.start("99833ae2-1f46-44b9-870f-991c73e3e3a8", withServices:[
            MSAnalytics.self,
            MSCrashes.self
            ])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // still debugging this
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Facebook invoked the recipe url scheme")
        return true
    }
    // still debugging this
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("Facebook invoked the recipe url scheme 2")
        return true
    }
    
}

