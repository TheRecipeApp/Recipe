//
//  Ingredient.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class Ingredient: NSObject {
	static var ingredientDictionary = NSDictionary()
	static var ingredientUnitDictionary = NSDictionary()
	
	private var name: String {
		get { return self.name }
		set { self.name = newValue }
	}
	private var image: PFFile? {
		get { return self.image }
		set { self.image = newValue }
	}
	private var calories: Int? {
		get { return self.calories }
		set { self.calories = newValue }
	}
	
	init(name: String, image: PFFile?, calories: Int?) {
		super.init()
		self.name = name
		self.image = image ?? nil
		self.calories = calories ?? 0
	}
	
	static func populateIngredientListDictionary() {
	}
	static func populateIngredientUnitsDictionary() {
	}
}
