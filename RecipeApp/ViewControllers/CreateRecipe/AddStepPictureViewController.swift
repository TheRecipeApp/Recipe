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
	@IBOutlet weak var ingredientsTable: UITableView!
	@IBOutlet weak var stepDescription: UITextView!
	@IBOutlet weak var stepImage: UIImageView!
	@IBOutlet weak var stepAudio: UIButton!
	
	var audioPlaying: Bool  = false
	var step: CookingStep?
	var audioPlayer: AVAudioPlayer?
	
    var steps:[CookingStep]?
    var stepNumber = 0;
	var stepImageUploaded = false
	
	// image picker
	let imagePickerController = UIImagePickerController()
	var recipeImageUploaded = false

	override func viewDidLoad() {
		super.viewDidLoad()
		ingredientsTable.delegate = self
		ingredientsTable.dataSource = self
		ingredientsTable.estimatedRowHeight = 50
		ingredientsTable.rowHeight = UITableViewAutomaticDimension
		let nibName = UINib(nibName: "IngredientsTableViewCell", bundle: nil)
		ingredientsTable.register(nibName, forCellReuseIdentifier: "IngredientsTableViewCell")
		ingredientsTable.separatorStyle = UITableViewCellSeparatorStyle.none
		
		audioPlayer?.delegate = self
		
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
        self.title = "Add Step \(stepNumber) - Description"
		step = steps?[stepNumber-1]

		// Do any additional setup after loading the view.
		stepDescription.text = step?.desc
		setupStepAudio()
	}
	
	func setupStepAudio() {
		if let audioFile = step?.stepAudio {
			stepAudio.isHidden = false
			audioFile.getDataInBackground(block: { (data: Data?, error: Error?) in
				if error == nil {
					if let audioData = data {
						do {
							try self.audioPlayer = AVAudioPlayer(data: audioData)
							self.audioPlayer?.delegate = self
						} catch {
							print("Unable to create audio player:", error.localizedDescription)
						}
					}
				}
			})
		} else {
			stepAudio.isHidden = true
		}
	}
	
	@IBAction func onDescriptionNext(_ sender: UIButton) {
		let cookingStep = steps?[stepNumber-1]
		if stepImageUploaded {
			cookingStep?.setImage(with: stepImage.image)
		}
		presentStepDone()
	}
	
	private func presentStepDone() {
		let alertController = UIAlertController()
		// Alert Saying Step Not Saved
		alertController.title = "Done With Steps?"
		// create a cancel action
		let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
			// handle cancel response here. Doing nothing will dismiss the view.
			self.performSegue(withIdentifier: "IngredientsViewSegue", sender: nil)
		}
		// add the cancel action to the alertController
		alertController.addAction(noAction)
		
		// create an OK action
		let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
			// handle response here.
			self.performSegue(withIdentifier: "RecipeSummarySegue", sender: nil)
		}
		// add the OK action to the alert controller
		alertController.addAction(yesAction)
		present(alertController, animated: true, completion: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func onTap(_ sender: UITapGestureRecognizer) {
		present(imagePickerController, animated: true, completion: nil)
		stepImageUploaded = true
	}
	
	@IBAction func onAudioPlayTapped(_ sender: Any) {
		stepAudio.setImage(#imageLiteral(resourceName: "speaker_on"), for: .normal)
		stepAudio.flash()
		audioPlayer?.play()
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

extension AddStepPictureViewController : UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (step?.ingredients?.count)!
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell", for: indexPath) as! IngredientsTableViewCell
		cell.ingredientNameLabel.text = step?.ingredients?[indexPath.row]
		if let amount = step?.ingredientAmounts[indexPath.row] {
			cell.ingredientAmountLabel.text = String("\(amount)")
		}
		cell.ingredientUnitsLabel.text = step?.ingredientUnits[indexPath.row]
		return cell
	}
}

extension AddStepPictureViewController : AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		stepAudio.stopFlash()
		stepAudio.setImage(#imageLiteral(resourceName: "speaker_off"), for: .normal)
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

