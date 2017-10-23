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
	@NSManaged var recipeId: String?
	@NSManaged var stepNumber: NSNumber
	@NSManaged var stepAudio: PFFile?
	
	// TODO: add a property to store video guide
	override init() {
		super.init()
	}

	func custom_init(recipeId: String, stepNumber: NSNumber, desc: String, ingredients: [Ingredient]?, ingredientAmounts: [Float]?, ingredientUnits: [String]?, image: PFFile?) {
		self.desc = desc
		self.stepNumber = stepNumber
		self.recipeId = recipeId
		self.ingredients = ingredients ?? [Ingredient]()
		self.ingredientAmounts = ingredientAmounts ?? [Float]()
		self.ingredientUnits = ingredientUnits ?? [String]()
		self.stepImage = image ?? nil
	}
	
	func setImage(with image: UIImage?) {
		// check if image is not nil
		if let recipeImage = image {
			// get image data and check if that is not nil
			if let imageData = UIImagePNGRepresentation(recipeImage) {
				self.stepImage = PFFile(name: "image.png", data: imageData)
			}
		}
	}
	
	func setAudioData(with data:NSData) {
		let file = PFFile(name:"stepAudio.m4a", data:data as Data)
		stepAudio = file
	}
}
