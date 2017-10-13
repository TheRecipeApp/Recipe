//
//  UserSettings.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

class UserSettings: NSObject {
	private var shareMyCooking: Bool {
		get { return self.shareMyCooking }
		set { self.shareMyCooking = newValue }
	}
	private var learnToCook: Bool {
		get { return self.learnToCook }
		set { self.learnToCook = newValue }
	}
	private var enablePushNotifications: Bool {
		get { return self.enablePushNotifications }
		set { self.enablePushNotifications = newValue }
	}
	private var favoriteCuisines: [String] {
		get { return self.favoriteCuisines }
		set { self.favoriteCuisines = newValue }
	}

	init(shareMyCooking : Bool?, learnToCook: Bool?, enablePushNotifications: Bool?, favoriteCuisines: [String]?) {
		super.init()
		self.shareMyCooking = shareMyCooking ?? false
		self.learnToCook = learnToCook ?? false
		self.enablePushNotifications = enablePushNotifications ?? false
		self.favoriteCuisines = favoriteCuisines ?? [String]()
	}
}
