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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
		self.performSegue(withIdentifier: "AddRecipeDetailsSegue", sender: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
    private func showPhotoPicker(type: UIImagePickerControllerSourceType) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        imagePickerViewController.sourceType = type
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
	@IBAction func onTap(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: "Set your profile picture", message: nil, preferredStyle: .actionSheet)
        
        // Make sure the simulator does not show the camera option
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.showPhotoPicker(type: UIImagePickerControllerSourceType.camera)
            }
            actionSheet.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showPhotoPicker(type: UIImagePickerControllerSourceType.photoLibrary)
        }
        actionSheet.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
		stepImageUploaded = true
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "IngredientsViewSegue" {
			let destVC = segue.destination as! IngredientsViewController
			destVC.steps = self.steps
		} else {
			// Get the new view controller using segue.destinationViewController.
			let addRecipeDetailsViewController = segue.destination as! AddRecipeDetailsViewController
			// Pass the selected object to the new view controller.
			addRecipeDetailsViewController.cookingSteps = steps
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

