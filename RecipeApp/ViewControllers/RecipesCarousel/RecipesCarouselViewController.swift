//
//  RecipesCarouselViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/17/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import iCarousel
import Parse

class RecipesCarouselViewController: UIViewController {

	@IBOutlet weak var recipesCarousel: iCarousel!
	var myRecipes = [Recipe]()
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		recipesCarousel.delegate = self
		recipesCarousel.dataSource = self
		
		// get the list of my recipes
		myRecipes.removeAll()
		let user = PFUser.current()
		let query = PFQuery(className: "Recipe")
		if let user = user {
			query.whereKey("owner", equalTo: user.objectId!)
			query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
				if error == nil {
					// The find succeeded.
					print("Successfully retrieved \(objects!.count) recipes.")
					// Do something with the found objects
					if let objects = objects {
						for object in objects {
							print(object.objectId!)
							self.myRecipes.append(object as! Recipe)
						}
						self.recipesCarousel.reloadData()
						self.recipesCarousel.type = .linear
					}
				} else {
					// Log details of the failure
					print("Error: \(error?.localizedDescription)")
				}
			})
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension RecipesCarouselViewController : iCarouselDelegate, iCarouselDataSource {
	func numberOfItems(in carousel: iCarousel) -> Int {
		return myRecipes.count
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		let tempView = RecipeBlockView(frame: CGRect(x: 0, y: 0, width: 172, height: 172))
		let recipeImageFile = myRecipes[index].image
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
		tempView.imgTag = "test"
		tempView.owner = PFUser.current()?.username
		tempView.title = myRecipes[index].name
		return tempView
	}
	
	func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
		if (option == iCarouselOption.spacing) {
			return value * 1.1
		}
		return value
	}
}
