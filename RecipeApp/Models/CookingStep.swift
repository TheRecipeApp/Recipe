//
//  CookingStep.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class CookingStep: NSObject {
	private var desc: String {
		get { return self.desc }
		set { self.desc = newValue }
	}
	private var ingredients: [Ingredient]? {
		get { return self.ingredients }
		set { self.ingredients = newValue }
	}
	private var ingredientAmounts: [Float] {
		get { return self.ingredientAmounts }
		set { self.ingredientAmounts = newValue }
	}
	private var ingredientUnits: [String] {
		get { return self.ingredientUnits }
		set { self.ingredientUnits = newValue }
	}
	
	private var stepImage: PFFile? {
		get { return self.stepImage }
		set { self.stepImage = newValue }
	}
	
	// TODO: add a property to store video guide

	init(desc: String, ingredients: [Ingredient]?, ingredientAmounts: [Float]?, ingredientUnits: [String]?, image: PFFile?) {
		super.init()
		self.desc = desc
		self.ingredients = ingredients ?? [Ingredient]()
		self.ingredientAmounts = ingredientAmounts ?? [Float]()
		self.ingredientUnits = ingredientUnits ?? [String]()
		self.stepImage = image ?? nil
	}
}
