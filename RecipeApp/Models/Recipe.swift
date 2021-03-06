//
//  Recipe.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class Recipe: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "Recipe"
	}
	 
    
    // Munchies
    static var categories = ["Desserts", "Fusion", "Vietnamese", "Indian", "American", "Mexican", "Barbeque", "Sushi", "Thanksgiving", "Guilty", "Italian", "Healthy", "Vegetarian", "Carbs", "Halloween"]
    
	static var cookingTechniques = ["Baking","Basting","Boiling","Boning","Brining","Broiling","Canning","Caramelizing","Chiffonade","Chopping","Cold Storage","Creaming","Cubing","Deep Frying","Deglazing","Degorging","Drying","Fermenting","Grilling","Julienning","Marinating","Melting","Microwaving","Mincing","Pickling","Poaching","Pressure Cooking","Puree","Roasting","Sauteing","Simmering","Slicing","Smoking","Soak","Spice rubs","Steaming","Stir Frying"]
	
	@NSManaged var name: String
	@NSManaged var owner: String?
    @NSManaged var ownerName: String?
	@NSManaged var desc: String?
	@NSManaged var cookingTime: String?
	@NSManaged var difficultyLevel: String?
	@NSManaged var cuisine: String?
	@NSManaged var likes: NSNumber?
	@NSManaged var shares: NSNumber?
	@NSManaged var calories: NSNumber?
	@NSManaged var servings: NSNumber?
	@NSManaged var image: PFFile?
	@NSManaged var category: String?
	@NSManaged var videoId: String? // assuming a youtube video id
	
	func setImage(with image: UIImage?) {
		// check if image is not nil
		if let recipeImage = image {
			// get image data and check if that is not nil
			if let imageData = UIImagePNGRepresentation(recipeImage) {
				self.image = PFFile(name: "image.png", data: imageData)
			}
		}
	}
	
	override init() {
		super.init()
	}	
}
