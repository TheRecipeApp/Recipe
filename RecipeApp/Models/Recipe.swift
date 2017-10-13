//
//  Recipe.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

enum RecipeDifficulty {
	case low
	case medium
	case high
	case expert
}

class Recipe: NSObject {
	static var cookingTechniques = ["Baking","Basting","Boiling","Boning","Brining","Broiling","Canning","Caramelizing","Chiffonade","Chopping","Cold Storage","Creaming","Cubing","Deep Frying","Deglazing","Degorging","Drying","Fermenting","Grilling","Julienning","Marinating","Melting","Microwaving","Mincing","Pickling","Poaching","Pressure Cooking","Puree","Roasting","Sauteing","Simmering","Slicing","Smoking","Soak","Spice rubs","Steaming","Stir Frying"]
	
	private var name: String {
		get { return self.name }
		set { self.name = newValue}
	}
	private var desc: String? {
		get { return self.desc }
		set { self.desc = newValue}
	}
	private var cookingTime: Int? {
		get { return self.cookingTime }
		set { self.cookingTime = newValue}
	}
	private var difficultyLevel: RecipeDifficulty? {
		get { return self.difficultyLevel }
		set { self.difficultyLevel = newValue}
	}
	private var cuisine: String? {
		get { return self.cuisine }
		set { self.cuisine = newValue}
	}
	private var likes: Int? {
		get { return self.likes }
		set { self.likes = newValue}
	}
	private var owner: UInt64 {
		get { return self.owner }
		set { self.owner = newValue}
	}
	private var shares: Int? {
		get { return self.shares }
		set { self.shares = newValue}
	}
	private var calories: Int? {
		get { return self.calories }
		set { self.calories = newValue}
	}
	private var servings: Int?{
		get { return self.servings }
		set { self.servings = newValue}
	}
	
	init(name: String, description: String?, owner: UInt64, cookingTime: Int?) {
		// TODO: finish implementation fo the init function with appropriate params and body of the function
		super.init()
		self.name = name
		self.desc = description
		self.cookingTime = cookingTime
		self.owner = owner
	}
}
