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

	override init() {
		super.init()
	}	
}
