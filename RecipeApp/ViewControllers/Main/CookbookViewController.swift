//
//  CookbookViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class CookbookViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cookbookNameLabel: UILabel!
    @IBOutlet weak var recipeCountLabel: UILabel!
    @IBOutlet weak var complimentCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var recipeCollectionView: UICollectionView!

    var cookbook: Cookbook?
    
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        self.recipeCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
        
        if view.traitCollection.forceTouchCapability == .available {
            print("Force touch is enabled for this device")
            registerForPreviewing(with: self, sourceView: self.recipeCollectionView)
        }
        
        if cookbook != nil {
            do {
                try cookbook!.fetchIfNeeded()
                try cookbook?.owner.fetchIfNeeded()
            } catch {
                print("[Error] Error while retriving the user")
            }
            cookbookNameLabel.text = cookbook?.name
            recipeCountLabel.text = "\(cookbook?.recipes?.count ?? 0)"
            print("Hello")
            print(cookbook?.recipes)
            complimentCountLabel.text = "\(cookbook?.likesAggregate ?? 0)"
            if let owner = cookbook?.owner as? User {
                usernameLabel.text = "@\(owner.username!)"
            } else {
                usernameLabel.text = ""
                print("User not found")
            }
            let imageFile = cookbook!.featuredImage
            if imageFile != nil {
                imageFile?.getDataInBackground(block: { (imageData: Data?, error: Error?) in
                    if error == nil {
                        if let imageData = imageData {
                            self.profileImageView.image = UIImage(data: imageData)
                        } else {
                            self.profileImageView.image = UIImage(named: "NoRecipeImage")
                        }
                    } else {
                        self.profileImageView.image = UIImage(named: "NoRecipeImage")
                    }
                })
            } else {
                self.profileImageView.image = UIImage(named: "NoRecipeImage")
            }
            fetchRecipes()
        } else{
            print("[ERROR] CookbookViewController cookbookId not set")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchRecipes() {
        let query = PFQuery(className: "Recipe")
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) recipes.")
                
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object as! Recipe)
                        self.recipes.append(object as! Recipe)
                    }
                }
                
                // reload the header section of this view
                self.recipeCountLabel.text = String(self.recipes.count)
                
                // reload the trending collection view
                self.recipeCollectionView.reloadData()
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

extension CookbookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var cell: RecipeCollectionViewCell? = nil
        cell = self.recipeCollectionView?.cellForItem(at: indexPath) as? RecipeCollectionViewCell
        let recipeVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
        recipeVC.recipeId = cell?.recipeId
        self.navigationController?.pushViewController(recipeVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        
        let recipe = self.recipes[indexPath.row]
        var recipeImageFile: PFFile? = nil
        recipeImageFile = recipe.image
        cell.recipeTitle.text = recipe.name
        cell.recipeId = recipe.objectId
        
        cell.recipe = recipe
        
        if recipeImageFile != nil {
            recipeImageFile?.getDataInBackground(block: { (imageData: Data?, error: Error?) in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        cell.recipeImage.image = image
                    }
                }
            })
        }
        
        cell.categoryLabel.text = recipe.category?.uppercased()
        cell.createdByLabel.text = "@\(recipe.ownerName ?? "alexdoan7")"
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
}

extension CookbookViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let collectionView = previewingContext.sourceView as! UICollectionView
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecipeCollectionViewCell else { return nil }
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        // in order to initialize the outlets on the view
        let view = detailVC.view
        
        detailVC.recipeId = cell.recipeId
        detailVC.recipe = cell.recipe
        detailVC.recipeImage.image = cell.recipeImage.image
        
        let recipe = cell.recipe
        if recipe != nil {
            if let nameStr = recipe?.name {
                detailVC.recipeName.text = nameStr
            }
            if let desc = recipe?.desc {
                detailVC.recipeDescription.text = desc
            }
            if let likes = recipe?.likes {
                detailVC.likesCount.text = "\(likes)"
            }
            if let ownerStr = cell.createdByLabel {
                detailVC.owner.text = ownerStr.text!
            }
        }
        
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 500)
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let collectionView = previewingContext.sourceView as! UICollectionView
        let recipeVC = storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
        let detailVC = viewControllerToCommit as! DetailViewController
        recipeVC.recipeId = detailVC.recipeId
        show(recipeVC, sender: self)
    }
}
