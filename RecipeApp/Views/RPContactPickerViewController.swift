//
//  RPContactPickerViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/26/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import ContactsUI

class RPContactPickerViewController: CNContactPickerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
