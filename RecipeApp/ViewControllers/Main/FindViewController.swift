//
//  FindViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/8/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class FindViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSearch(_ sender: UIButton) {
        print("Search button pressed")
    }
    
    @IBAction func onProfile(_ sender: UIBarButtonItem) {
        print("Profile button pressed")
    }
    
    @IBAction func onAddRecipe(_ sender: UIBarButtonItem) {
        print("Add recipe button pressed")
    }
    
	@IBAction func onLogout(_ sender: Any) {
		PFUser.logOut()
		let storyboard = UIStoryboard(name: "Login", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! UINavigationController
		self.present(vc, animated: true, completion: nil)
	}
}

