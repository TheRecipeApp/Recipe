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
    @IBOutlet var searchButton: UIButton!
    
    var recipes = [Recipe]()
    var isSearchShown = false
    var categories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        
        // For setting up peek and pop functionality
        if (view.traitCollection.forceTouchCapability == .available) {
            print("force touch is enabled for this device")
            registerForPreviewing(with: self, sourceView: self.collectionView)
        }
        
        collectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.categoryView.subviews.forEach { (view: UIView) in
            addTapRecognizer(to: view as! UILabelCategory)
        }
        
        self.noResultsLabel.isHidden = true
//        fetchCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapView(_ sender: Any) {
        print("tapped on view")
        self.searchBar.endEditing(true)
    }
    
    func addTapRecognizer(to label: UILabel) {
        label.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FindViewController.categoryTapped(tapGestureRecognizer:)))
        label.addGestureRecognizer(tapRecognizer)
    }
    
    @IBAction func onShowSearch(_ sender: UIButton) {
        if isSearchShown == true {
            searchBar.isHidden = true
            categoryView.isHidden = false
        } else {
            searchBar.isHidden = false
            categoryView.isHidden = true
        }
        isSearchShown = !isSearchShown
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
            let index = self.categories.index(where: { (key: String) -> Bool in
                return key == label.text!.lowercased()
            })
            if let index = index {
                categories.remove(at: index)
            }
        } else {
            let color = UIColor(named: "PrimaryColor")
            self.categories.append(label.text!.lowercased())
            label.backgroundColor = color
        }
        
        label.isActive = !label.isActive
        doSearch(nil, categories: true)
    }
    
    func recipeTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Recipe tapped")
        let recipeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
        
        let recipeView = tapGestureRecognizer.view as! RecipeBlockView
        recipeDetailVC.recipeId = recipeView.recipeId
        
        self.navigationController?.pushViewController(recipeDetailVC, animated: true)
    }
    
    
//    func fetchCategories() {
//        let query = PFQuery(className: "Recipe")
//        query.countObjectsInBackground { (count: Int, error: Error?) in
//            <#code#>
//        }
//        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
//
//        }
//    }
    //_ searchString: String?, category: Bool
    
    func doSearch(_ searchTerm: String?, categories: Bool) {
        
        searchBar.resignFirstResponder()
        recipes.removeAll()
        
        var query: PFQuery? = nil
        if categories {
            var queries: [PFQuery] = [PFQuery]()
            self.categories.forEach({ (category: String) in
                let query = PFQuery(className: "Recipe")
                let searchTermRegex = String(format: "(?i)%@", category)
                query.whereKey("category", matchesRegex: searchTermRegex)
                queries.append(query)
            })
            if queries.count > 0 {
                query = PFQuery.orQuery(withSubqueries: queries)
            }
        } else {
            if let searchTerm = searchTerm {
                var queries: [PFQuery] = [PFQuery]()
                
                let searchTermRegex = String(format: "(?i)%@", searchTerm)
                
                let query1 = PFQuery(className: "Recipe")
                query1.whereKey("category", matchesRegex: searchTermRegex)
                
                let query2 = PFQuery(className: "Recipe")
                query2.whereKey("cuisine", matchesRegex: searchTermRegex)

                let query3 = PFQuery(className: "Recipe")
                query3.whereKey("name", matchesRegex: searchTermRegex)
                
                queries.append(query1)
                queries.append(query2)
                queries.append(query3)
                
                query = PFQuery.orQuery(withSubqueries: queries)
            }
        }
        
        if let query = query {
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
                            //                        self.noResultsLabel.isHidden = false
                            self.collectionView.isHidden = true
                        }
                    }
                }
            })
        }
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
        onShowSearch(UIButton())
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch(searchBar.text, categories: false)
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
        cell.recipe = recipe
        cell.categoryLabel.text = recipe.category?.uppercased()
        cell.createdByLabel.text = "@\(recipe.ownerName!)"
        cell.recipeTitle.text = recipe.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView?.cellForItem(at: indexPath) as? RecipeCollectionViewCell
        let recipeVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
        recipeVC.recipeId = cell?.recipeId
        self.navigationController?.pushViewController(recipeVC, animated: true)
    }
}

extension FindViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        var indexPath: IndexPath?
        var cell: RecipeCollectionViewCell?
        
        indexPath = self.collectionView?.indexPathForItem(at: location)
        if indexPath != nil {
            cell = self.collectionView?.cellForItem(at: indexPath!) as? RecipeCollectionViewCell
            if cell == nil { return nil }
        }
        
        if indexPath == nil {
            return nil
        } else {
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            
            // in order to initialize the outlets on the view
            let view = detailVC.view
            
            detailVC.recipeId = cell!.recipeId
            detailVC.recipe = cell!.recipe
            detailVC.recipeImage.image = cell!.recipeImage?.image
            
            let recipe = cell!.recipe
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
                if let ownerStr = cell?.createdByLabel {
                    detailVC.owner.text = ownerStr.text!
                }
            }
            
            detailVC.preferredContentSize = CGSize(width: 0.0, height: 500)
            previewingContext.sourceRect = cell!.frame
            
            return detailVC
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let recipeVC = storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
        let detailVC = viewControllerToCommit as! DetailViewController
        recipeVC.recipeId = detailVC.recipeId
        show(recipeVC, sender: self)
    }
}

