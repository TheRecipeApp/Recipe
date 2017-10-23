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

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var recipesCarousel: iCarousel!
    @IBOutlet weak var searchBar: UISearchBar!
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        recipesCarousel.delegate = self
        recipesCarousel.dataSource = self
        searchBar.delegate = self
        searchBar.sizeToFit()
        
        self.recipesCarousel.contentOffset = CGSize(width: 0, height: 0)
        self.categoryView.subviews.forEach { (view: UIView) in
            print(view.debugDescription)
            let label = view as! UILabel
            addTapRecognizer(to: label)
        }
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
        let primaryColor = UIColor(named: "PrimaryColor")
        let label = tapGestureRecognizer.view as! UILabel
        label.backgroundColor = primaryColor
        doSearch()
    }
    
    func recipeTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Recipe tapped")
        let recipeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
        
        let recipeView = tapGestureRecognizer.view as! RecipeBlockView
        recipeDetailVC.recipeBlockView = recipeView
        
        self.navigationController?.pushViewController(recipeDetailVC, animated: true)
    }
    
	@IBAction func onLogout(_ sender: Any) {
		PFUser.logOut()
		let storyboard = UIStoryboard(name: "Login", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! UINavigationController
		self.present(vc, animated: true, completion: nil)
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
                    for object in objects {
                        print(object.objectId!)
                        self.recipes.append(object as! Recipe)
                    }
                    self.recipesCarousel.reloadData()
                    self.recipesCarousel.type = .linear
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

extension FindViewController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return recipes.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView = RecipeBlockView(frame: CGRect(x: 0, y: 0, width: 172, height: 172))
        let recipeImageFile = recipes[index].image
        if recipeImageFile != nil {
            recipeImageFile?.getDataInBackground(block: { (imageData: Data?, error: Error?) in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        tempView.image = image
                    }
                }
            })
        }
        
        tempView.recipeId = recipes[index].objectId
        tempView.imgTag = "test"
        tempView.owner = PFUser.current()?.username
        tempView.title = recipes[index].name
        tempView.isUserInteractionEnabled = true
        
        let recipeTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FindViewController.recipeTapped(tapGestureRecognizer:)))
        tempView.addGestureRecognizer(recipeTapRecognizer)
        
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == iCarouselOption.spacing) {
            return value * 1.1
        }
        
        
        return value
    }
}

