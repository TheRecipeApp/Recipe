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
    
    @IBOutlet weak var trendingCarousel: iCarousel!
    
    @IBOutlet weak var favoritesCarousel: iCarousel!
    @IBOutlet weak var localTrendsCarousel: iCarousel!
    
    fileprivate var trending = [Recipe]()
    fileprivate var favorites = [Recipe]()
    fileprivate var localTrends = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.trendingCarousel.delegate = self
        self.trendingCarousel.dataSource = self
        
        self.favoritesCarousel.delegate = self
        self.favoritesCarousel.dataSource = self

        self.localTrendsCarousel.delegate = self
        self.localTrendsCarousel.dataSource = self
        
        fetchRecipes(carouselName: "trending")
        fetchRecipes(carouselName: "favorites")
        fetchRecipes(carouselName: "localTrends")
    }
    
    func fetchRecipes(carouselName type: String) {
        let query = PFQuery(className: "Recipe")
        //query.whereKey("owner", equalTo: "eW8xBBf8t4")
        let user = PFUser.current()
        if let user = user {
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
                                    self.trendingCarousel.type = .linear
                                    self.trendingCarousel.reloadData()
                                case "favorites":
                                    self.favorites.append(object as! Recipe)
                                    self.favoritesCarousel.type = .linear
                                    self.favoritesCarousel.reloadData()
                                case "localTrends":
                                    self.localTrends.append(object as! Recipe)
                                    self.localTrendsCarousel.type = .linear
                                    self.localTrendsCarousel.reloadData()
                                default:
                                    print("unrecognized carousel type")
                            }
                        }
                    }
                }
            })
        }
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
        let recipeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
        
        let recipeView = tapGestureRecognizer.view as! RecipeBlockView
        recipeDetailVC.recipeBlockView = recipeView
        
        self.navigationController?.pushViewController(recipeDetailVC, animated: true)
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

extension ExploreViewController: iCarouselDelegate, iCarouselDataSource {

    func numberOfItems(in carousel: iCarousel) -> Int {
        if carousel == self.trendingCarousel {
            return self.trending.count
        } else if carousel == self.favoritesCarousel {
            return self.favorites.count
        } else if carousel == self.localTrendsCarousel {
            return self.localTrends.count
        } else {
            return 0
        }
        
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if self.trending.isEmpty {
            print("trending is empty, returning empty view")
            return UIView()
        }
        let tempView = RecipeBlockView(frame: CGRect(x: 0, y: 0, width: 172, height: 172))
        let recipeImageFile = self.trending[index].image
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

        tempView.recipeId = self.trending[index].objectId
        tempView.imgTag = "test"
        tempView.owner = PFUser.current()?.username
        tempView.title = self.trending[index].name
        tempView.isUserInteractionEnabled = true

        let recipeTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ExploreViewController.recipeTapped(tapGestureRecognizer:)))
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

