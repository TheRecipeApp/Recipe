//
//  Cookbook.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

class Cookbook: NSObject {
	private var name: String {
		get { return self.name }
		set { self.name = newValue }
	}
	private var category: String? {
		get { return self.category }
		set { self.category = newValue }
	}
	private var cuisine: String? {
		get { return self.cuisine }
		set { self.cuisine = newValue }
	}
	private var tags: [String]? {
		get { return self.tags }
		set { self.tags = newValue }
	}
	private var owner: UInt64 {
		get { return self.owner }
		set { self.owner = newValue }
	}
	private var recipes: [Recipe]? {
		get { return self.recipes }
		set { self.recipes = newValue }
	}

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
