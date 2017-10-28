//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class RecipeViewController: UIViewController {
	// recipe items
	@IBOutlet weak var recipeName: UILabel!
	@IBOutlet weak var recipeDescription: UILabel!
	@IBOutlet weak var timeToCook: UILabel!
	@IBOutlet weak var difficulty: UILabel!
	@IBOutlet weak var cuisine: UILabel!
	@IBOutlet weak var category: UILabel!
	@IBOutlet weak var recipeImage: UIImageView!
	@IBOutlet weak var owner: UILabel!
	@IBOutlet weak var cookThisButton: UIButton!
	
	var recipeId : String?
	var recipe: Recipe?
	var recipeOwner: User?
	
	// cooking steps
	var cookingSteps = [CookingStep]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view.
		cookThisButton.setTitle("No Steps", for: .disabled)
		// fetch the cooking steps for the recipe
		fetchRecipe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setupRecipeFields() {
		if recipe != nil {
			if let nameStr = recipe?.name {
				recipeName.text = nameStr
			}
			if let desc = recipe?.desc {
				recipeDescription.text = desc
			}
			if let cookingTime = recipe?.cookingTime {
				timeToCook.text = cookingTime
			}
			if let difficultyLevel = recipe?.difficultyLevel {
				difficulty.text = difficultyLevel
			}
			if let cuisineStr = recipe?.cuisine {
				cuisine.text = cuisineStr
			}
			if let categoryStr = recipe?.category {
				category.text = categoryStr
			}
			if let ownerStr = recipeOwner?.username {
				owner.text = "@" + ownerStr
			} else {
				owner.text = "@..."
			}
			// get recipe image
			setupRecipeImage()
		}
	}
	
	private func fetchOwner() {
		if let user = User.fetchUser(by: (recipe?.owner)!) {
			recipeOwner = user
			setupRecipeFields()
		} else {
			print("error retrieving user: " + (recipe?.owner)!)
		}
	}
	
	private func setupRecipeImage() {
		let imageFile = recipe?.image
		imageFile?.getDataInBackground(block: { (data: Data?, error: Error?) in
			if error == nil {
				if let imageData = data {
					self.recipeImage.image = UIImage(data: imageData)
					self.recipeImage.contentMode = .scaleAspectFit
				}
			}
		})
	}

	func fetchRecipe() {
		let query = PFQuery(className: "Recipe")
		query.whereKey("objectId", equalTo: self.recipeId!)
		query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
			if error == nil {
				// The find succeeded.
				print("Successfully retrieved \(objects!.count) cooking steps.")
				// Do something with the found objects
				if let objects = objects {
					self.recipe = objects[0] as? Recipe
					self.fetchOwner()
					self.fetchCookingSteps()
				}
			}
		})
	}
	
	func fetchCookingSteps() {
		self.cookingSteps.removeAll()
		let query = PFQuery(className: "CookingStep")
		query.whereKey("recipeId", equalTo: self.recipeId!)
		query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
			if error == nil {
				// The find succeeded.
				print("Successfully retrieved \(objects!.count) cooking steps.")
				// Do something with the found objects
				if let objects = objects {
					for object in objects {
						let cookingStep = object as! CookingStep
						print("cooking step: \(cookingStep)")
						self.cookingSteps.append(cookingStep)
					}
				}
				print("number of cooking steps: \(self.cookingSteps.count)")
			}
			if self.cookingSteps.count == 0 {
				self.cookThisButton.isEnabled = false
			}
		})
	}

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		let destVC = segue.destination as! CookingStepViewController
		destVC.steps = cookingSteps
    }

}
