//
//  User.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class User: PFObject {
	private var email: String {
		get { return self.email }
		set { self.email = newValue }
	}
	private var screenName: String {
		get { return self.screenName }
		set { self.screenName = newValue }
	}
	private var password: String {
		get {return self.password}
		// TODO: hash the password value
		set {self.password = newValue }
	}
	private var firstName: String {
		get { return self.firstName }
		set { self.firstName = newValue }
	}
	private var lastName: String? {
		get { return self.lastName }
		set { self.lastName = newValue }
	}
	private var name: String {
		get { return self.firstName + " " + self.lastName! }
	}
	private var stars: Int? {
		get { return self.stars }
		set { self.stars = newValue }
	}
	private var following: [UInt64]? { // array of user object ids that the current user is following
		get { return self.following }
		set { self.following = newValue }
	}
	private var followers: [UInt64]? { // array of ids of users who are following the current user
		get { return self.followers }
		set { self.followers = newValue }
	}
	private var cookbooks: [UInt64]? { // list of cookbook ids that the current user is interested in
		get { return self.cookbooks }
		set { self.cookbooks = newValue }
	}
	private var settings: UserSettings {
		get { return self.settings }
		set { self.settings = newValue }
	}
	private var phone: String {
		get { return self.phone }
		set { self.phone = newValue }
	}
	// TODO: need to setup the profile image field
	private var profileImage: PFFile? {
		get { return self.profileImage }
		set { self.profileImage = newValue }
	}
	
	
	
	init(email: String, screenName: String, firstName: String, lastName: String?, phone: String, shareMyCooking: Bool?, learnToCook: Bool?, enablePushNotifications: Bool?, favoriteCuisines: [String]?) {
		super.init()
		self.email = email
		self.screenName = screenName
		self.firstName = firstName
		self.lastName = lastName
		self.phone = phone
		self.stars = 0
		self.followers = [UInt64]()
		self.following = [UInt64]()
		self.cookbooks = [UInt64]()
		self.settings = UserSettings(shareMyCooking: shareMyCooking, learnToCook: learnToCook, enablePushNotifications: enablePushNotifications, favoriteCuisines: favoriteCuisines)
	}
}
