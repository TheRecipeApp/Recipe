//
//  FindViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/8/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import iCarousel
import MBProgressHUD

class FindViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var noResultsLabel: UILabel!
    
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        
        collectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.categoryView.subviews.forEach { (view: UIView) in
            addTapRecognizer(to: view as! UILabelCategory)
        }
        
        self.noResultsLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTapRecognizer(to label: UILabel) {
        label.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FindViewController.categoryTapped(tapGestureRecognizer:)))
        label.addGestureRecognizer(tapRecognizer)
    }
    
    @IBAction func onProfile(_ sender: UIBarButtonItem) {
        print("Profile button pressed")
    }
    
    @IBAction func onAddRecipe(_ sender: UIBarButtonItem) {
        print("Add recipe button pressed")
    }
    
    func categoryTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Category tapped")
        let label = tapGestureRecognizer.view as! UILabelCategory
        if label.isActive == true {
            let color = UIColor(named: "GraySmallHeader")
            label.backgroundColor = color
        } else {
            let color = UIColor(named: "PrimaryColor")
            label.backgroundColor = color
        }
        label.isActive = !label.isActive
        doSearch()
    }
    
    func recipeTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Recipe tapped")
        let recipeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
        
        let recipeView = tapGestureRecognizer.view as! RecipeBlockView
        recipeDetailVC.recipeId = recipeView.recipeId
        
        self.navigationController?.pushViewController(recipeDetailVC, animated: true)
    }
    
	func doSearch() {
        searchBar.resignFirstResponder()
        recipes.removeAll()
        let query = PFQuery(className: "Recipe")
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) recipes.")
                // Do something with the found objects
                if let objects = objects {
                    if objects.count > 0 {
                        self.noResultsLabel.isHidden = true
                        self.collectionView.isHidden = false
                        for object in objects {
                            print(object.objectId!)
                            self.recipes.append(object as! Recipe)
                        }
                        self.collectionView.reloadData()
                    } else {
                        self.noResultsLabel.isHidden = false
                        self.collectionView.isHidden = true
                    }
                }
            }
        })
    }
}

// SearchBar methods
extension FindViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
}

extension FindViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        let recipe = self.recipes[indexPath.row]
        
        let recipeImageFile = recipe.image
        if recipeImageFile != nil {
            recipeImageFile?.getDataInBackground(block: { (imageData: Data?, error: Error?) in
                if error == nil {
                    if let imageData = imageData {
                        cell.recipeImage.image = UIImage(data: imageData)
                    }
                }
            })
        }
        cell.recipeId = recipe.objectId
        cell.categoryLabel.text = recipe.category?.uppercased()
        if let owner = User.fetchUser(by: recipe.owner!) {
            cell.createdByLabel.text = "by @\(owner.username!)"
        } else {
            cell.createdByLabel.text = ""
        }
        cell.recipeTitle.text = recipe.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TODO: Navigate to the recipe detail")
    }
}

