//
//  RecipeSummaryViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/19/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices

class RecipeSummaryViewController: UIViewController {
	@IBOutlet weak var recipeStepsTable: UITableView!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var categoryTextField: UITextField!
	@IBOutlet weak var cuisineTextField: UITextField!
	@IBOutlet weak var difficultyTextField: UITextField!
	@IBOutlet weak var timeToCookTextField: UITextField!
	@IBOutlet weak var descriptionTextField: UITextField!
	@IBOutlet weak var recipeImage: UIImageView!
	var cookingSteps: [CookingStep]? = nil
	let imagePickerController = UIImagePickerController()
	var recipeImageUploaded = false
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		recipeStepsTable.delegate = self
		recipeStepsTable.dataSource = self
		recipeStepsTable.estimatedRowHeight = 100
		recipeStepsTable.rowHeight = UITableViewAutomaticDimension

		if let cookingSteps = cookingSteps {
			if cookingSteps.count > 0 {
				// initialize the steps in the steps table
			}
		}
		imagePickerController.delegate = self
		imagePickerController.allowsEditing = true
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			print("Camera is available 📸")
			imagePickerController.sourceType = .camera
		} else {
			print("Camera 🚫 available so we will use photo library instead")
			imagePickerController.sourceType = .photoLibrary
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func onSaveRecipe(_ sender: Any) {
		// save the recipe
		let recipe = Recipe()
		let owner = PFUser.current()
		if (owner == nil) {
			let alertController = UIAlertController()
			// create an OK action
			let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
				// handle response here.
				let storyboard = UIStoryboard(name: "Login", bundle: nil)
				let vc = storyboard.instantiateInitialViewController() as! UINavigationController
				self.present(vc, animated: true, completion: nil)
			}
			// add the OK action to the alert controller
			alertController.addAction(OKAction)
			alertController.title = "NO Current User. Please Login"
			present(alertController, animated: true, completion: nil)
		} else {
			recipe.owner = owner?.objectId
			if let name = nameTextField.text {
				setupRecipe(recipe: recipe, name: name)
				// save the recipe
				recipe.saveInBackground(block: { (success: Bool, error: Error?) in
					if (success) {
						// save the cooking steps for the recipe
						self.saveCookingSteps(recipeId: recipe.objectId!)
					} else {
						print("Unable to Save Recipe")
						print("Error: \(String(describing: error?.localizedDescription))")
					}
				})
			} else {
				// name is a required field
				print("requires name of recipe")
				nameTextField.becomeFirstResponder()
			}
		}
	}
	
	private func saveCookingSteps(recipeId: String) {
		for step in self.cookingSteps! {
			step.recipeId = recipeId
			step.saveInBackground(block: { (success: Bool, error: Error?) in
				if success {
					print("Saved Cooking Step")
					let storyboard = UIStoryboard(name: "Main", bundle: nil)
					let vc = storyboard.instantiateInitialViewController() as! UITabBarController
					self.present(vc, animated: true, completion: nil)
				} else {
					print("Error Saving Step: ", error?.localizedDescription ?? "")
				}
			})
		}
	}
	
	private func setupRecipe(recipe : Recipe, name: String) {
		recipe.name = name
		if let cuisine = cuisineTextField.text {
			recipe.cuisine = cuisine
		}
		if let category = categoryTextField.text {
			recipe.category = category
		}
		if let difficulty = difficultyTextField.text {
			recipe.difficultyLevel = difficulty
		}
		if let timeToCook = timeToCookTextField.text {
			recipe.cookingTime = timeToCook
		}
		if let desc = descriptionTextField.text {
			recipe.desc = desc
		}
		if recipeImageUploaded {
			recipe.setImage(with: recipeImage.image)
		}
	}
	
	@IBAction func onTaop(_ sender: UITapGestureRecognizer) {
		present(imagePickerController, animated: true, completion: nil)
		recipeImageUploaded = true
	}
	
	// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
		let stepDetailsController = segue.destination as! StepDetailsViewController
        // Pass the selected object to the new view controller.
		let indexPath = recipeStepsTable.indexPathForSelectedRow
		stepDetailsController.step = cookingSteps?[(indexPath?.row)!]
    }
}

extension RecipeSummaryViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (cookingSteps != nil) {
			return (cookingSteps?.count)!
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeStepCell", for: indexPath) as! RecipeStepCell
		cell.stepNumberLabel.text = String("\(indexPath.row + 1):")
		cell.stepDescriptionLabel.text = cookingSteps?[indexPath.row].desc
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "StepDetailsSegue", sender: nil)
	}
}

extension RecipeSummaryViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		// Get the image captured by the UIImagePickerController
		let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
		
		self.recipeImage.contentMode = .center
		self.recipeImage.contentMode = .scaleAspectFit
		if editedImage != nil {
			self.recipeImage.image = editedImage
		} else {
			self.recipeImage.image = originalImage
		}
		
		// Dismiss UIImagePickerController to go back to your original view controller
		dismiss(animated: true, completion: nil)
	}
}

