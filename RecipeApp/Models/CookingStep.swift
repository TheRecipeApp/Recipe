//
//  CookingStep.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class CookingStep: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "CookingStep"
	}
	
	@NSManaged var desc: String
	@NSManaged var ingredients: [Ingredient]?
	@NSManaged var ingredientAmounts: [Float]
	@NSManaged var ingredientUnits: [String]
	@NSManaged var stepImage: PFFile?
	@NSManaged var recipeId: UInt64
	@NSManaged var stepNumber: NSNumber
	
	// TODO: add a property to store video guide
	override init() {
		super.init()
	}

	func custom_init(recipeId: UInt64, stepNumber: NSNumber, desc: String, ingredients: [Ingredient]?, ingredientAmounts: [Float]?, ingredientUnits: [String]?, image: PFFile?) {
		self.desc = desc
		self.stepNumber = stepNumber
		self.recipeId = recipeId
		self.ingredients = ingredients ?? [Ingredient]()
		self.ingredientAmounts = ingredientAmounts ?? [Float]()
		self.ingredientUnits = ingredientUnits ?? [String]()
		self.stepImage = image ?? nil
	}
}
