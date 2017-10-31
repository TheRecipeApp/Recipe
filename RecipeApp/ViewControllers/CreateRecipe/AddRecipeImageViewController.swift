//
//  AddRecipeImageViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/30/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices

class AddRecipeImageViewController: UIViewController {
    @IBOutlet weak var recipeImage: UIImageView!
    var cookingSteps: [CookingStep]? = nil
    var recipe: Recipe?
    let imagePickerController = UIImagePickerController()
    var recipeImageUploaded = false
    var nameFieldEntered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        
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
        // save the recipe image
        if recipeImageUploaded {
            recipe?.setImage(with: recipeImage.image)
        }
        // save the recipe
        do {
            try recipe?.save()
            self.saveCookingSteps(recipeId: (recipe?.objectId)!)
        } catch {
            print("Error Saving Recipe, ", error.localizedDescription)
        }
        performSegue(withIdentifier: "RecipeViewController", sender: nil)
    }
    
    private func saveCookingSteps(recipeId: String) {
        print("Recipe Id for Cooking Step:\(recipeId)")
        for step in self.cookingSteps! {
            step.recipeId = recipeId
            do {
                try step.save()
            } catch {
                print("Error Saving Step, ", error.localizedDescription)
            }
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
        let destVC = segue.destination as! RecipeViewController
        destVC.recipeId = self.recipe?.objectId
        destVC.fromRecipeCreate = true
    }
}

extension AddRecipeImageViewController : UITableViewDelegate, UITableViewDataSource {
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

extension AddRecipeImageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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


