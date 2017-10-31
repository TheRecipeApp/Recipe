//
//  AddRecipeDetailsViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/30/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices

class AddRecipeDetailsViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var cuisineTextField: UITextField!
    @IBOutlet weak var difficultyTextField: UITextField!
    @IBOutlet weak var timeToCookTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    var cookingSteps: [CookingStep]? = nil
    var nameFieldEntered = false
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        
        if let cookingSteps = cookingSteps {
            if cookingSteps.count > 0 {
                // initialize the steps in the steps table
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onNextTapped(_ sender: Any) {
        // save the recipe
        if let nameField = nameTextField, let name = nameTextField.text {
            if (!name.isEmpty) {
                recipe = Recipe()
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
                    recipe?.owner = owner?.objectId
                    if let name = nameTextField.text {
                        setupRecipe(name: name)
                        performSegue(withIdentifier: "AddRecipeImageSegue", sender: nil)
                    } else {
                        // name is a required field
                        print("requires name of recipe")
                        nameTextField.becomeFirstResponder()
                    }
                }
            } else {
                presentAlert(alertTitle: "Requires Name of Recipe", showCancel: false)
                nameTextField.becomeFirstResponder()
            }
        } else {
            presentAlert(alertTitle: "Requires Name of Recipe", showCancel: false)
            nameTextField.becomeFirstResponder()
        }
    }
    
    private func presentAlert(alertTitle:String, showCancel: Bool) {
        let alertController = UIAlertController()
        // Alert Saying Step Not Saved
        print(alertTitle)
        // create a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        if (showCancel) {
            alertController.addAction(cancelAction)
        }
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        alertController.title = alertTitle
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupRecipe(name: String) {
        recipe?.name = name
        if let cuisine = cuisineTextField.text {
            recipe?.cuisine = cuisine
        }
        if let category = categoryTextField.text {
            recipe?.category = category
        }
        if let difficulty = difficultyTextField.text {
            recipe?.difficultyLevel = difficulty
        }
        if let timeToCook = timeToCookTextField.text {
            recipe?.cookingTime = timeToCook
        }
        if let desc = descriptionTextField.text {
            recipe?.desc = desc
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let destVC = segue.destination as! AddRecipeImageViewController
        destVC.recipe = self.recipe
        destVC.cookingSteps = self.cookingSteps
    }
}
