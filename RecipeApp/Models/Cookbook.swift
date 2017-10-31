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
    @NSManaged var likesAggregate: Int
    @NSManaged var recipes: [String]?
    @NSManaged var owner: PFUser
    @NSManaged var featuredImage: PFFile?
    
    // Not in this release
//    @NSManaged var category: String?
//    @NSManaged var cuisine: String?
//    @NSManaged var tags: [String]?
	
	override init() {
		super.init()
	}	
}
