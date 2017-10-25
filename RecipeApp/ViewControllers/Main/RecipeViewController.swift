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

	@IBOutlet weak var stepNumber: UILabel!
	@IBOutlet weak var stepDescription: UILabel!
	@IBOutlet weak var ingredientsTable: UITableView!
	@IBOutlet weak var stepImage: UIImageView!
	@IBOutlet weak var stepAudioButton: UIButton!
	@IBOutlet weak var nextStepButton: UIButton!
	@IBOutlet weak var prevStepButton: UIButton!
	
	// recipe items
	@IBOutlet weak var recipeName: UILabel!
	@IBOutlet weak var recipeDescription: UILabel!
	@IBOutlet weak var timeToCook: UILabel!
	@IBOutlet weak var difficulty: UILabel!
	@IBOutlet weak var cuisine: UILabel!
	@IBOutlet weak var category: UILabel!
	@IBOutlet weak var recipeImage: UIImageView!
	var recipeId : String?
	var recipe: Recipe?
	var origStepTraversalButtonColor : UIColor?
	
	// cooking steps
	var cookingSteps = [CookingStep]()
	var stepId = 0;
	var audioPlayer: AVAudioPlayer?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view.
		recipeImage.layer.borderWidth = 1
		stepImage.layer.borderWidth = 1
		
		ingredientsTable.delegate = self
		ingredientsTable.dataSource = self
		ingredientsTable.estimatedRowHeight = 100
		ingredientsTable.rowHeight = UITableViewAutomaticDimension
		let nibName = UINib(nibName: "IngredientsTableViewCell", bundle: nil)
		ingredientsTable.register(nibName, forCellReuseIdentifier: "IngredientsTableViewCell")
		
		prevStepButton.isEnabled = false
		origStepTraversalButtonColor = prevStepButton.titleColor(for: .normal)

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
			// get recipe image
			setupRecipeImage()
		}
	}
	
	func setupRecipeImage() {
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
					self.setupRecipeFields()
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
				self.setupStepDetails()
				print("number of cooking steps: \(self.cookingSteps.count)")
			}
		})
	}

	func setupStepDetails() {
		setupStepImage()
		setupStepAudio()
		self.stepNumber.text = String("\(stepId + 1)")
		self.stepDescription.text = cookingSteps[stepId].desc
		self.ingredientsTable.reloadData()
	}
	
	func setupStepAudio() {
		if let audioFile = cookingSteps[stepId].stepAudio {
			stepAudioButton.isEnabled = true
			stepAudioButton.setImage(#imageLiteral(resourceName: "speaker_on"), for: .normal)
			audioFile.getDataInBackground(block: { (data: Data?, error: Error?) in
				if error == nil {
					if let audioData = data {
						do {
							try self.audioPlayer = AVAudioPlayer(data: audioData)
						} catch {
							print("Unable to create audio player:", error.localizedDescription)
						}
					}
				}
			})
		} else {
			stepAudioButton.isEnabled = false
			stepAudioButton.setImage(#imageLiteral(resourceName: "speaker_off"), for: .normal)
		}
	}
	
	func setupStepImage() {
		let imageFile = cookingSteps[stepId].stepImage
		imageFile?.getDataInBackground(block: { (data: Data?, error: Error?) in
			if error == nil {
				if let imageData = data {
					self.stepImage.image = UIImage(data: imageData)
					self.stepImage.contentMode = .scaleAspectFit
				}
			}
		})
	}

	@IBAction func onPreviousStepTapped(_ sender: Any) {
		stepId = stepId - 1
		if stepId == 0 {
			prevStepButton.isEnabled = false
			prevStepButton.setTitleColor(UIColor.gray, for: .normal)
		} else {
			nextStepButton.isEnabled = true
			nextStepButton.setTitleColor(origStepTraversalButtonColor, for: .normal)
		}
		setupStepDetails()
	}
	
	@IBAction func onNextStepTapped(_ sender: Any) {
		stepId = stepId + 1
		stepNumber.text = String("\(stepId + 1)")
		if stepId == cookingSteps.count - 1 {
			nextStepButton.isEnabled = false
			nextStepButton.setTitleColor(UIColor.gray, for: .normal)
		} else {
			prevStepButton.isEnabled = true
			prevStepButton.setTitleColor(origStepTraversalButtonColor, for: .normal)
		}
		setupStepDetails()
	}
	
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecipeViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if cookingSteps.isEmpty {
			return 0
		} else if cookingSteps[stepId].ingredients != nil {
			return (cookingSteps[stepId].ingredients?.count)!
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell") as! IngredientsTableViewCell
		print("Cooking Step Id: \(cookingSteps[stepId])")
		let ingredients = cookingSteps[stepId].ingredients
		let ingredientAmounts = cookingSteps[stepId].ingredientAmounts
		let ingredientUnits = cookingSteps[stepId].ingredientUnits
		if (!(ingredients?.isEmpty)!) {
			let ingredient = ingredients?[indexPath.row]
			cell.customInit(name: ingredient!, amount: ingredientAmounts[indexPath.row], units: ingredientUnits[indexPath.row])
		}
		return cell
	}
	
}


