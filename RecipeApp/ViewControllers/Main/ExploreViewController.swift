//
//  ExploreViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var localTrendsCollectionView: UICollectionView!
    
    fileprivate var trending = [Recipe]()
    fileprivate var favorites = [Recipe]()
    fileprivate var localTrends = [Recipe]()
    
    var animatedTrending: Set<Int>?
    var animatedFavorites: Set<Int>?
    var animatedLocalTrends: Set<Int>?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set up animation datastructures
        self.animatedTrending = []
        self.animatedFavorites = []
        self.animatedLocalTrends = []
        
        // Set up delegate and datasource
        self.trendingCollectionView.dataSource = self
        self.trendingCollectionView.delegate = self
        self.favoritesCollectionView.dataSource = self
        self.favoritesCollectionView.delegate = self
        self.localTrendsCollectionView.dataSource = self
        self.localTrendsCollectionView.delegate = self
        
        // For setting up peek and pop functionality
        if (view.traitCollection.forceTouchCapability == .available) {
            print("force touch is enabled for this device")
            registerForPreviewing(with: self, sourceView: self.trendingCollectionView)
            registerForPreviewing(with: self, sourceView: self.favoritesCollectionView)
            registerForPreviewing(with: self, sourceView: self.localTrendsCollectionView)
        }
        
        // For using custom xib for each recipe
        self.trendingCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        self.favoritesCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        self.localTrendsCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCollectionViewCell")

        
        // for pull-down refresh action
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching...")
        self.scrollView.insertSubview(refreshControl, at: 0)
        
        fetchRecipes(collectionViewName: "trending")
        fetchRecipes(collectionViewName: "favorites")
        fetchRecipes(collectionViewName: "localTrends")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchRecipes(collectionViewName type: String) {
        switch type {
            case "trending":
                let query = PFQuery(className: "Recipe")
                query.order(byDescending: "likes")
                query.limit = 5
                query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                    if error == nil {
                        print("Successfully retrieved \(objects!.count) recipes for collectionView: \(type).")
                        if let objects = objects {
                            for object in objects {
                                print(object as! Recipe)
                                self.trending.append(object as! Recipe)
                            }
                        }
                        self.trendingCollectionView.reloadData()
                    }
                })
            case "favorites":
                let query = PFQuery(className: "Recipe")
                query.order(byDescending: "likes")
                query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                    if error == nil {
                        print("Successfully retrieved \(objects!.count) recipes for collectionView: \(type).")
                        if let objects = objects {
                            for object in objects {
                                print(object as! Recipe)
                                self.favorites.append(object as! Recipe)
                            }
                        }
                        self.favoritesCollectionView.reloadData()
                    }
                })
            case "localTrends":
                let query = PFQuery(className: "Recipe")
                query.order(byDescending: "likes")
                query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                    if error == nil {
                        print("Successfully retrieved \(objects!.count) recipes for collectionView: \(type).")
                        if let objects = objects {
                            for object in objects {
                                print(object as! Recipe)
                                self.localTrends.append(object as! Recipe)
                            }
                        }
                        self.localTrendsCollectionView.reloadData()
                    }
                })
            default:
                print("unrecognized collectionView type type")
        }
        
    }

    @objc private func refreshControlAction(_ refreshControl: UIRefreshControl) {
        print("Refresh action called")
        animatedTrending = []
        animatedFavorites = []
        animatedLocalTrends = []
        fetchRecipes(collectionViewName: "trending")
        fetchRecipes(collectionViewName: "favorites")
        fetchRecipes(collectionViewName: "localTrends")
        refreshControl.endRefreshing()
    }
    
    
//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
// leave this here incase we need it again
//        if let segueId = segue.identifier {
//            switch segueId {
//                case "trendingToRecipeVC":
//                    let recipeVC = segue.destination as! RecipeViewController
//                    if let cell = sender as? RecipeCollectionViewCell, let indexPath = trendingCollectionView.indexPath(for: cell) {
//                        trendingCollectionView.deselectItem(at: indexPath, animated: true)
//                        recipeVC.recipeId = cell.recipeId
//                    }
//                default:
//                    print("Unrecognzied segue")
//            }
//        }
    }
    

}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var cell: RecipeCollectionViewCell? = nil
        
        if collectionView == self.trendingCollectionView {
            cell = self.trendingCollectionView?.cellForItem(at: indexPath) as? RecipeCollectionViewCell
        } else if collectionView == self.favoritesCollectionView {
            cell = self.favoritesCollectionView?.cellForItem(at: indexPath) as? RecipeCollectionViewCell
        } else {
            cell = self.localTrendsCollectionView?.cellForItem(at: indexPath) as? RecipeCollectionViewCell
        }
        
        let recipeVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
        recipeVC.recipeId = cell?.recipeId
        self.navigationController?.pushViewController(recipeVC, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.trendingCollectionView {
            return trending.count
        } else if collectionView == self.favoritesCollectionView {
            return favorites.count
        } else {
            return localTrends.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        cell.isUserInteractionEnabled = true
        
        var recipeImageFile: PFFile? = nil
        
        if collectionView == self.trendingCollectionView {
            let recipe = self.trending[indexPath.row]
           
            cell.recipeId = recipe.objectId
            cell.recipe = recipe
            cell.recipeTitle.text = recipe.name
            cell.categoryLabel.text = recipe.category?.uppercased()
            recipeImageFile = recipe.image
            cell.createdByLabel.isHidden = true
            if !(animatedTrending?.contains(indexPath.row))! {
                cell.backgroundColor = .white
                cell.alpha = 0
                UIView.animate(withDuration: 0.50, animations: {
                    cell.alpha = 1
                    self.animatedTrending!.insert(indexPath.row)
                })
            }
        } else if collectionView == self.favoritesCollectionView {
            let recipe = self.favorites[indexPath.row]
            
            cell.recipeId = recipe.objectId
            cell.recipe = recipe
            cell.recipeTitle.text = recipe.name
            cell.categoryLabel.text = recipe.category?.uppercased()
            recipeImageFile = recipe.image
            cell.createdByLabel.isHidden = true
            if !(animatedFavorites?.contains(indexPath.row))! {
                cell.backgroundColor = .white
                cell.alpha = 0
                UIView.animate(withDuration: 0.50, animations: {
                    cell.alpha = 1
                    self.animatedFavorites!.insert(indexPath.row)
                })
            }
            
        } else {
            let recipe = self.localTrends[indexPath.row]

            cell.recipeId = recipe.objectId
            cell.recipe = recipe
            cell.recipeTitle.text = recipe.name
            cell.categoryLabel.text = recipe.category?.uppercased()
            recipeImageFile = recipe.image
            cell.createdByLabel.isHidden = true
            if !(animatedLocalTrends?.contains(indexPath.row))! {
                cell.backgroundColor = .white
                cell.alpha = 0
                UIView.animate(withDuration: 0.50, animations: {
                    cell.alpha = 1
                    self.animatedLocalTrends!.insert(indexPath.row)
                })
            }
        }
        
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
        
        return cell
    }
    
}

extension ExploreViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        var indexPath: IndexPath?
        var cell: RecipeCollectionViewCell?
        
        if previewingContext.sourceView == self.trendingCollectionView {
            indexPath = self.trendingCollectionView?.indexPathForItem(at: location)
            if indexPath != nil {
                cell = self.trendingCollectionView?.cellForItem(at: indexPath!) as? RecipeCollectionViewCell
            }
        } else if previewingContext.sourceView == self.favoritesCollectionView {
            indexPath = self.favoritesCollectionView?.indexPathForItem(at: location)
            if indexPath != nil {
                cell = self.favoritesCollectionView?.cellForItem(at: indexPath!) as? RecipeCollectionViewCell
            }
        } else {
            indexPath = self.localTrendsCollectionView?.indexPathForItem(at: location)
            if indexPath != nil {
                cell = self.localTrendsCollectionView?.cellForItem(at: indexPath!) as? RecipeCollectionViewCell
            }
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

