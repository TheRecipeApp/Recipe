//
//  User.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class User: PFUser {
	@NSManaged var screenName: String?
	@NSManaged var firstName: String?
	@NSManaged var lastName: String?
	private var name: String {
		get { return self.firstName! + " " + self.lastName! }
	}
	@NSManaged var stars: NSNumber?
	@NSManaged var following: [UInt64]?
	@NSManaged var followers: [UInt64]?
	@NSManaged var settings: UserSettings?
	@NSManaged var phone: String?
	@NSManaged var profileImage: PFFile?
    @NSManaged var preference: Int
	
	func custom_init(screenName: String?, firstName: String?, lastName: String?, phone: String?, shareMyCooking: Bool?, learnToCook: Bool?, enablePushNotifications: Bool?, favoriteCuisines: [String]?, stars: NSNumber?) {
		self.email = email
		self.screenName = screenName
		self.firstName = firstName
		self.lastName = lastName
		self.phone = phone
		self.stars = 0
		self.followers = [UInt64]()
		self.following = [UInt64]()
		self.settings = UserSettings(shareMyCooking: shareMyCooking, learnToCook: learnToCook, enablePushNotifications: enablePushNotifications, favoriteCuisines: favoriteCuisines)
		self.stars = stars
        self.preference = -1
		self.saveInBackground(block: { (success, error) in
			if (success) {
				// The object has been saved.
				print("User: " + self.username! + " saved with additional attributes")
			} else {
				// There was a problem, check error.description
				print("Unable to save User attributes for User: " + self.username!)
				print("error: " + (error?.localizedDescription)!)
			}
		})
	}
	
	static func fetchUser(by objectId: String) -> User? {
		let query = PFUser.query()
		query?.whereKey("objectId", equalTo: objectId)
		do {
			let objects = try query?.findObjects()
			if let objects = objects {
				for object in objects {
					return object as? User
				}
			}
			return nil
		} catch {
			print("error retrieving user: " + objectId + ", \(error.localizedDescription)")
			return nil
		}
	}

}
