//
//  WelcomeViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/29/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

	var steps:[CookingStep]?
	var stepsSaved = false
	
	@IBOutlet weak var addStepsButton: UIButton!
	@IBOutlet weak var showStepsButton: UIButton!
	@IBOutlet weak var clearStepsButton: UIButton!
	@IBOutlet weak var saveRecipeButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		if (stepsSaved) {
			addStepsButton.isEnabled = false
			showStepsButton.isEnabled = true
			clearStepsButton.isEnabled = true
			saveRecipeButton.isEnabled = true
		} else {
			addStepsButton.isEnabled = true
			showStepsButton.isEnabled = false
			clearStepsButton.isEnabled = false
			saveRecipeButton.isEnabled = false
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func showSteps(_ sender: Any) {
		performSegue(withIdentifier: "StepDetailsSegue", sender: nil)
	}
	
	@IBAction func clearSteps(_ sender: Any) {
		stepsSaved = false
		steps?.removeAll();
		addStepsButton.isEnabled = true
		showStepsButton.isEnabled = false
		clearStepsButton.isEnabled = false
		saveRecipeButton.isEnabled = false
	}
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "SaveRecipeSegue") {
			// Get the new view controller using segue.destinationViewController.
			// Pass the selected object to the new view controller.
			let destVC = segue.destination as! UINavigationController
			let addRecipeDetailsController = destVC.topViewController as! AddRecipeDetailsViewController
			addRecipeDetailsController.cookingSteps = steps
		}
		if (segue.identifier == "StepDetailsSegue") {
			let destVC = segue.destination as! UINavigationController
			let stepDetailsController = destVC.topViewController as! StepDetailsViewController
			stepDetailsController.steps = steps
		}
    }
}
