//
//  Cookbook.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class Cookbook: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "Cookbook"
	}
	
	@NSManaged var name: String
	@NSManaged var category: String?
	@NSManaged var cuisine: String?
	@NSManaged var tags: [String]?
	@NSManaged var owner: UInt64
	@NSManaged var recipes: [Recipe]?

	init(name: String, owner: UInt64, category: String?, cuisine: String?, tags: [String]?, recipes: [Recipe]?) {
		super.init()
		self.name = name
		self.owner = owner
		self.category = category ?? nil
		self.cuisine = cuisine ?? nil
		self.tags = tags ?? [String]()
		self.recipes = recipes ?? [Recipe]()
	}
}
