//
//  AddStepPictureViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/29/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//


import UIKit
import AVFoundation

class AddStepPictureViewController: UIViewController {
	@IBOutlet weak var stepImage: UIImageView!
	
	var step: CookingStep?
    var steps:[CookingStep]?
    var stepNumber = 0;
	var stepImageUploaded = false
	
	// image picker
	let imagePickerController = UIImagePickerController()

	override func viewDidLoad() {
		super.viewDidLoad()
        // image picker
		imagePickerController.delegate = self
		imagePickerController.allowsEditing = true
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			print("Camera is available 📸")
			imagePickerController.sourceType = .camera
		} else {
			print("Camera 🚫 available so we will use photo library instead")
			imagePickerController.sourceType = .photoLibrary
		}
		
        stepNumber = (steps?.count)!
        self.title = "Add Step\(stepNumber) Image"
		step = steps?[stepNumber-1]
	}
	
	@IBAction func onNextStep(_ sender: Any) {
		let cookingStep = steps?[stepNumber-1]
		if stepImageUploaded {
			cookingStep?.setImage(with: stepImage.image)
		}
		self.performSegue(withIdentifier: "IngredientsViewSegue", sender: nil)
	}
	
	@IBAction func onSaveRecipe(_ sender: Any) {
		let cookingStep = steps?[stepNumber-1]
		if stepImageUploaded {
			cookingStep?.setImage(with: stepImage.image)
		}
		self.performSegue(withIdentifier: "RecipeSummarySegue", sender: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func onTap(_ sender: UITapGestureRecognizer) {
		present(imagePickerController, animated: true, completion: nil)
		stepImageUploaded = true
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "IngredientsViewSegue" {
			let destVC = segue.destination as! IngredientsViewController
			destVC.steps = self.steps
		} else {
			// Get the new view controller using segue.destinationViewController.
			let recipeSummaryViewController = segue.destination as! RecipeSummaryViewController
			// Pass the selected object to the new view controller.
			recipeSummaryViewController.cookingSteps = steps
		}
	}
}

extension AddStepPictureViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		// Get the image captured by the UIImagePickerController
		let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
		
		self.stepImage.contentMode = .center
		self.stepImage.contentMode = .scaleAspectFit
		if editedImage != nil {
			self.stepImage.image = editedImage
		} else {
			self.stepImage.image = originalImage
		}
		
		// Dismiss UIImagePickerController to go back to your original view controller
		dismiss(animated: true, completion: nil)
	}
}

