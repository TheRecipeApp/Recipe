//
//  NewRecipeViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

class NewRecipeViewController: UIViewController {

	@IBOutlet weak var ingredientTextField: UITextField!
	@IBOutlet weak var amountTextField: UITextField!
	@IBOutlet weak var unitsTextField: UITextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupTextFieldAtributes(field: ingredientTextField, string: "Ingredient")
		setupTextFieldAtributes(field: amountTextField, string: "Amount")
		setupTextFieldAtributes(field: unitsTextField, string: "Units")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	private func setupTextFieldAtributes(field: UITextField, string: String) {
		let width = CGFloat(2.0)
		field.textColor = UIColor.white
		let fieldBorder = CALayer()
		fieldBorder.borderColor = UIColor.white.cgColor
		fieldBorder.frame = CGRect(x: 0, y: field.frame.size.height - width, width:  field.frame.size.width, height: field.frame.size.height)
		fieldBorder.borderWidth = width
		field.layer.addSublayer(fieldBorder)
		field.layer.masksToBounds = true
		field.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.white])
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
