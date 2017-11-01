//
//  UserSettings.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class UserSettings: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "UserSettings"
	}
	
	@NSManaged var shareMyCooking: Bool
	@NSManaged var learnToCook: Bool
	@NSManaged var enablePushNotifications: Bool
	@NSManaged var favoriteCuisines: [String]
    
    override init() {
        super.init()
    }
    
	init(shareMyCooking : Bool?, learnToCook: Bool?, enablePushNotifications: Bool?, favoriteCuisines: [String]?) {
		super.init()
		self.shareMyCooking = shareMyCooking ?? false
		self.learnToCook = learnToCook ?? false
		self.enablePushNotifications = enablePushNotifications ?? false
		self.favoriteCuisines = favoriteCuisines ?? [String]()
	}
}
