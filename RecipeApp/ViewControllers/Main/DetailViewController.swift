//
//  DetailViewController.swift
//  RecipeApp
//
//  Created by Alexander Doan on 10/24/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController {
    
    @IBOutlet weak var categoryLabel: UILabelCategory!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    
    var recipeId: String?
    var recipe: Recipe?
    var recipeOwner: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeDescription.sizeToFit()
        recipeName.sizeToFit()
        owner.sizeToFit()
        categoryLabel.sizeToFit()
        
//        setupRecipeFields()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setupRecipeFields() {
//        print("Setting up recipe fields in DetailViewController")
//        if recipe != nil {
//            if let nameStr = recipe?.name {
//                recipeName.text = nameStr
//            }
//            if let desc = recipe?.desc {
//                recipeDescription.text = desc
//            }
//            if let likes = recipe?.likes {
//                likesCount.text = "\(likes)"
//            }
//            if let ownerStr = recipeOwner?.username {
//                owner.text = "@" + ownerStr
//            } else {
//                owner.text = "@..."
//            }
//        }
//    }
    
//    func fetchRecipe() {
//        let query = PFQuery(className: "Recipe")
//        query.whereKey("objectId", equalTo: self.recipeId!)
//        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) cooking steps.")
//                // Do something with the found objects
//                if let objects = objects {
//                    self.recipe = objects[0] as? Recipe
//                    self.fetchOwner()
//                }
//            }
//        })
//    }
//
//    private func setupRecipeImage() {
//        let imageFile = recipe?.image
//        imageFile?.getDataInBackground(block: { (data: Data?, error: Error?) in
//            if error == nil {
//                if let imageData = data {
//                    self.recipeImage.image = UIImage(data: imageData)
//                    self.recipeImage.contentMode = .scaleAspectFit
//                }
//            }
//        })
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
