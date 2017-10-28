//
//  ExploreViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse
import iCarousel
import MBProgressHUD

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var localTrendsCollectionView: UICollectionView!
    
    fileprivate var trending = [Recipe]()
    fileprivate var favorites = [Recipe]()
    fileprivate var localTrends = [Recipe]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (view.traitCollection.forceTouchCapability == .available) {
            print("force touch is enabled for this device")
            registerForPreviewing(with: self, sourceView: self.trendingCollectionView)
            registerForPreviewing(with: self, sourceView: self.favoritesCollectionView)
            registerForPreviewing(with: self, sourceView: self.localTrendsCollectionView)
        }
        
        self.trendingCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        self.favoritesCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        self.localTrendsCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCollectionViewCell")

        self.trendingCollectionView.dataSource = self
        self.trendingCollectionView.delegate = self
       
        self.favoritesCollectionView.dataSource = self
        self.favoritesCollectionView.delegate = self
        
        self.localTrendsCollectionView.dataSource = self
        self.localTrendsCollectionView.delegate = self
        
        fetchRecipes(carouselName: "trending")
        fetchRecipes(carouselName: "favorites")
        fetchRecipes(carouselName: "localTrends")
    }
    
    func fetchRecipes(carouselName type: String) {
        let query = PFQuery(className: "Recipe")
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                print("CarouselType: \(type)")
                
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) recipes.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object as! Recipe)
                        switch type {
                        case "trending":
                            self.trending.append(object as! Recipe)
                        case "favorites":
                            self.favorites.append(object as! Recipe)
                        case "localTrends":
                            self.localTrends.append(object as! Recipe)
                        default:
                            print("unrecognized carousel type")
                        }
                    }
                }
                
                // reload the trending collection view
                self.trendingCollectionView.reloadData()
                self.favoritesCollectionView.reloadData()
                self.localTrendsCollectionView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onProfile(_ sender: UIBarButtonItem) {
        print("Profile button pressed")
    }
    
    @IBAction func onAddRecipe(_ sender: Any) {
        print("Add recipe button pressed")
    }
    
    func recipeTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Recipe tapped")
//        let recipeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
//
//        let recipeView = tapGestureRecognizer.view as! RecipeColl
//        recipeDetailVC.recipeId = recipeView.recipeId!
//
//        self.navigationController?.pushViewController(recipeDetailVC, animated: true)
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

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        
        var recipeImageFile: PFFile? = nil
        if collectionView == self.trendingCollectionView {
            recipeImageFile = self.trending[indexPath.row].image
            cell.recipeTitle.text = self.trending[indexPath.row].name
        } else if collectionView == self.favoritesCollectionView {
            recipeImageFile = self.favorites[indexPath.row].image
            cell.recipeTitle.text = self.favorites[indexPath.row].name
        } else {
            recipeImageFile = self.localTrends[indexPath.row].image
            cell.recipeTitle.text = self.localTrends[indexPath.row].name
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
        
        cell.categoryLabel.text = "image tag"
        cell.createdByLabel.text = PFUser.current()?.username
//        cell.recipeTitle.text = self.trending[indexPath.row].name
        cell.isUserInteractionEnabled = true
        
        let recipeTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ExploreViewController.recipeTapped(tapGestureRecognizer:)))
        cell.addGestureRecognizer(recipeTapRecognizer)

        return cell
    }
    
}
extension ExploreViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = self.trendingCollectionView?.indexPathForItem(at: location) else { return nil }
        guard let cell = self.trendingCollectionView?.cellForItem(at: indexPath) as? RecipeCollectionViewCell else { return nil }

        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        // in order to initialize outlets on the view
        let view = detailVC.view
        detailVC.imageView.image = cell.recipeImage?.image
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 500)
        previewingContext.sourceRect = cell.frame
        return detailVC
     }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

