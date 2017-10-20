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
	@IBOutlet weak var stepNumberLabel: UILabel!
	@IBOutlet weak var ingredientsTable: UITableView!
	@IBOutlet weak var stepDescriptionTextField: UITextField!
	
	private var stepNumber: Int = 0
	var steps = [CookingStep]()
	var stepIngredients = [Ingredient]()
	var stepIngredientAmounts = [Float]()
	var stepIngredientUnits = [String]()
	var stepNotSaved = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		ingredientsTable.delegate = self
		ingredientsTable.dataSource = self
		ingredientsTable.estimatedRowHeight = 50
		ingredientsTable.rowHeight = UITableViewAutomaticDimension
		let nibName = UINib(nibName: "IngredientsTableViewCell", bundle: nil)
		ingredientsTable.register(nibName, forCellReuseIdentifier: "IngredientsTableViewCell")

		stepNumberLabel.text = String("\(stepNumber)")

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
		field.textColor = UIColor.black
		let fieldBorder = CALayer()
		fieldBorder.borderColor = UIColor.black.cgColor
		fieldBorder.frame = CGRect(x: 0, y: field.frame.size.height - width, width:  field.frame.size.width, height: field.frame.size.height)
		fieldBorder.borderWidth = width
		field.layer.addSublayer(fieldBorder)
		field.layer.masksToBounds = true
		field.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.white])
	}

	@IBAction func onCancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func clearIngredient(_ sender: Any) {
		clearIngregientLabels()
	}
	
	private func clearAll() {
		clearIngregientLabels()
		stepIngredientUnits.removeAll()
		stepIngredientAmounts.removeAll()
		stepIngredients.removeAll()
		self.stepDescriptionTextField.text = ""
		stepNotSaved = false
	}
	
	private func clearIngregientLabels() {
		ingredientTextField.text = ""
		amountTextField.text = ""
		unitsTextField.text = ""
	}
	
	@IBAction func addIngredient(_ sender: Any) {
		if let name = ingredientTextField.text {
			let ingredient = Ingredient(name: name, image: nil, calories: 0)
			stepIngredients.append(ingredient)
			if let amountStr = amountTextField.text, let amount = Float(amountStr) {
				stepIngredientAmounts.append(amount)
			}
			else {
				print("InvalidAmount")
				stepIngredients.removeLast()
				amountTextField.becomeFirstResponder()
				stepNotSaved = true
			}
			if let units = unitsTextField.text {
				stepIngredientUnits.append(units)
				ingredientTextField.becomeFirstResponder()
				ingredientsTable.reloadData()
			} else {
				print("Invalid Units")
				stepIngredients.removeLast()
				stepIngredientAmounts.removeLast()
				unitsTextField.becomeFirstResponder()
			}
		} else {
			print("Invalid Ingredient Name")
			ingredientTextField.becomeFirstResponder()
		}
		clearIngregientLabels()
	}
	
	@IBAction func onSave(_ sender: UIButton) {
		if let stepDesc = stepDescriptionTextField.text {
			let cookingStep = CookingStep()
			cookingStep.desc = stepDesc
			cookingStep.ingredients = stepIngredients
			cookingStep.ingredientAmounts = stepIngredientAmounts
			cookingStep.ingredientUnits = stepIngredientUnits
			steps.append(cookingStep)
			stepNumber = stepNumber + 1
			stepNumberLabel.text = String("\(stepNumber)")
			stepDescriptionTextField.text = ""
			ingredientTextField.becomeFirstResponder()
			clearAll()
		} else {
			print("step description is not present")
			stepDescriptionTextField.becomeFirstResponder()
		}
	}
	
	@IBAction func stepDescriptionChanged(_ sender: Any) {
		stepNotSaved = true
	}
	
	@IBAction func onDone(_ sender: UIButton) {
		if stepNotSaved {
			let alertController = UIAlertController()
			// Alert Saying Step Not Saved
			print("Step Not Saved")
			// create a cancel action
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
				// handle cancel response here. Doing nothing will dismiss the view.
			}
			// add the cancel action to the alertController
			alertController.addAction(cancelAction)
			
			// create an OK action
			let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
				// handle response here.
				self.clearAll()
			}
			// add the OK action to the alert controller
			alertController.addAction(OKAction)
			alertController.title = "Step Not Saved, Clear Current Step?"
		} else {
			performSegue(withIdentifier: "RecipeSummarySegue", sender: nil)
		}
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
		let recipeSummaryViewController = segue.destination as! RecipeSummaryViewController
        // Pass the selected object to the new view controller.
		recipeSummaryViewController.cookingSteps = steps
    }

}

extension NewRecipeViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (stepIngredients.count > 0) {
			return stepIngredients.count
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = ingredientsTable.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell", for: indexPath) as! IngredientsTableViewCell
		cell.customInit(name: stepIngredients[indexPath.row].name, amount: stepIngredientAmounts[indexPath.row], units: stepIngredientUnits[indexPath.row])
		return cell
	}
}
