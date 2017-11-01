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
    @IBOutlet var categoryLabel: UILabelCategory!
	@IBOutlet weak var recipeImage: UIImageView!
	@IBOutlet weak var owner: UILabel!
	@IBOutlet weak var cookThisButton: UIButton!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    var recipeId : String?
	var recipe: Recipe?
	var recipeOwner: User?
    var isLiked: Bool = false
    var fromRecipeCreate = false
	
	// cooking steps
	var cookingSteps = [CookingStep]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view.
		cookThisButton.setTitle("No Steps", for: .disabled)
		cookThisButton.layer.cornerRadius = 3
		// fetch the cooking steps for the recipe
		fetchRecipe()
        
        categoryLabel.isHidden = true
        
        owner.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(RecipeViewController.goToProfile(tapGestureRecognizer:)))
        owner.addGestureRecognizer(tapRecognizer)
        if fromRecipeCreate {
            cookThisButton.setTitle("ViewSteps", for: .normal)
        }
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
				categoryLabel.text = categoryStr.uppercased()
                categoryLabel.isHidden = false
			}
            if let likes = recipe?.likes {
                likesCount.text = "\(likes) Compliments"
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
				}
			}
		})
	}

	func fetchRecipe() {
		let query = PFQuery(className: "Recipe")
		query.whereKey("objectId", equalTo: self.recipeId!)
		do {
			let objects:[PFObject]? = try query.findObjects()
			print("Successfully retrieved \(objects?.count) cooking steps.")
			// Do something with the found objects
			if let objects = objects {
				self.recipe = objects[0] as? Recipe
				self.fetchOwner()
				self.fetchCookingSteps()
			}
		} catch {
			print("Unable to fetch Recipe Details", error.localizedDescription)
		}
	}
	
	func fetchCookingSteps() {
		self.cookingSteps.removeAll()
		let query = PFQuery(className: "CookingStep")
		query.whereKey("recipeId", equalTo: self.recipeId!)
        query.order(byAscending: "createdAt")
		do {
			let objects:[PFObject]? = try query.findObjects()
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
			if self.cookingSteps.count == 0 {
				self.cookThisButton.isEnabled = false
			}
		} catch {
			print("Unable to fetch cooking steps", error.localizedDescription)
		}
	}
    
    // MARK: - Actions

    @IBAction func onLikeTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.likeButton.alpha = 0.1
        }, completion:{(finished) in
            if self.isLiked == true {
                self.likeButton.setImage(UIImage(named: "LikeOff"), for: .normal)
            } else {
                self.likeButton.setImage(UIImage(named: "LikeOn"), for: .normal)
            }
            UIView.animate(withDuration: 0.3, animations:{
                self.likeButton.alpha = 1.0
            },completion:nil)
            
            self.isLiked = !self.isLiked
        })
    }
    
    func goToProfile(tapGestureRecognizer: UITapGestureRecognizer) {
        print("User profile tapped")
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.userId = recipeOwner!.objectId
        self.navigationController?.pushViewController(profileVC, animated: true)
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
