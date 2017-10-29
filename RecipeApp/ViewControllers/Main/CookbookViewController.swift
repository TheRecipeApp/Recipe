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

    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        self.recipeCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
        
        fetchRecipes()
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
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//
//        let padding = 50
//        let collectionViewSize = collectionView.frame.size.width
//
//
//        return CGSizeMake(collectionViewSize/2, collectionViewSize/2)
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        
        var recipeImageFile: PFFile? = nil
        recipeImageFile = self.recipes[indexPath.row].image
        cell.recipeTitle.text = self.recipes[indexPath.row].name
        cell.recipeId = self.recipes[indexPath.row].objectId
        
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
        
        cell.categoryLabel.text = "image tag"
        cell.createdByLabel.text = PFUser.current()?.username
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
}
