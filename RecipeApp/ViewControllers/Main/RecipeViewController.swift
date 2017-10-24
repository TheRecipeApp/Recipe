//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import iCarousel
import Parse

class RecipeViewController: UIViewController {

	@IBOutlet weak var recipeName: UILabel!
	@IBOutlet weak var recipeDescription: UILabel!
	@IBOutlet weak var timeToCook: UILabel!
	@IBOutlet weak var difficulty: UILabel!
	@IBOutlet weak var cuisine: UILabel!
	@IBOutlet weak var category: UILabel!
	@IBOutlet weak var recipeImage: UIImageView!
	@IBOutlet weak var stepsCarousel: iCarousel!
	var recipeId : String?
	var cookingSteps = [CookingStep]()
	var recipe: Recipe?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view.
		stepsCarousel.delegate = self
		stepsCarousel.dataSource = self
		recipeImage.layer.borderWidth = 1

		// fetch the cooking steps for the recipe
		fetchRecipe()
		stepsCarousel.type = .linear
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
		query.whereKey("objectId", equalTo: self.recipeId)
		query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
			if error == nil {
				// The find succeeded.
				print("Successfully retrieved \(objects!.count) cooking steps.")
				// Do something with the found objects
				if let objects = objects {
					self.recipe = objects[0] as! Recipe
					self.setupRecipeFields()
					self.fetchCookingSteps()
					self.stepsCarousel.reloadData()
				}
			}
		})
	}
	
	func fetchCookingSteps() {
		let query = PFQuery(className: "CookingStep")
		query.whereKey("recipeId", equalTo: self.recipeId)
		query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
			if error == nil {
				// The find succeeded.
				print("Successfully retrieved \(objects!.count) cooking steps.")
				// Do something with the found objects
				if let objects = objects {
					for object in objects {
						let cookingStep = object as! CookingStep
						self.cookingSteps.append(cookingStep)
					}
				}
			}
		})
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

extension RecipeViewController : iCarouselDelegate, iCarouselDataSource {
	func numberOfItems(in carousel: iCarousel) -> Int {
		return cookingSteps.count
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		let stepView = CookingStepView(frame: CGRect(x: 0, y: 0, width: 270, height: 274))
		stepView.stepDescription.text = cookingSteps[index].desc
//		setupStepImage(for: stepView, index: index)
//		setupStepAudio(cookingSteps[index])
		return stepView
	}

//	func setupStepAudio(for view: CookingStepView, step: CookingStep) {
//		let audioFile = step?.stepAudio
//		audioFile?.getDataInBackground(block: { (data: Data?, error: Error?) in
//			if error == nil {
//				if let audioData = data {
//					do {
//						try self.audioPlayer = AVAudioPlayer(data: audioData)
//					} catch {
//						print("Unable to create audio player:", error.localizedDescription)
//					}
//				}
//			}
//		})
//	}
	
	func setupStepImage(for view: CookingStepView, index: Int) {
		let step = cookingSteps[index]
		let imageFile = step.stepImage
		imageFile?.getDataInBackground(block: { (data: Data?, error: Error?) in
			if error == nil {
				if let imageData = data {
					view.stepImage.image = UIImage(data: imageData)
					view.stepImage.contentMode = .scaleAspectFit
				}
			}
		})
	}

}

extension RecipeViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell") as! IngredientsTableViewCell
		return cell
	}
	
	
}
