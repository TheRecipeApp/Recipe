//
//  CreateViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/18/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let storyboard = UIStoryboard(name: "RecipesCarousel", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "RecipesCarouselView")
		self.present(vc, animated: true, completion: nil)
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
