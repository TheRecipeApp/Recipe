//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import iCarousel

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
	@IBOutlet weak var stepsCarousel: iCarousel!
	var recipeBlockView: RecipeBlockView?
	var recipe: Recipe?
//	var cookingSteps: [CookingStep]
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   
        if let recipeBlockView = recipeBlockView {
            self.recipeImage.image = recipeBlockView.image
        }
        
		// Do any additional setup after loading the view.
		stepsCarousel.delegate = self
		stepsCarousel.dataSource = self
		stepsCarousel.reloadData()
		stepsCarousel.type = .linear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func initializeCookingSteps() {
		let recipeId = recipe?.objectId
		
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

extension RecipeViewController : iCarouselDelegate, iCarouselDataSource {
	func numberOfItems(in carousel: iCarousel) -> Int {
		return 5
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		let view = CookingStepView(frame: CGRect(x: 0, y: 0, width: 270, height: 274))
		return view
	}
}

extension RecipeViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell") as! IngredientsTableViewCell
		return cell
	}
	
	
}
