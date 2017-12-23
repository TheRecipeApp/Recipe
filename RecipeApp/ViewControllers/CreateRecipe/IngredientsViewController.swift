//
//  IngredientsViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/29/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//
import UIKit
import Speech
import AVFoundation
import ActionSheetPicker_3_0

class IngredientsViewController: UIViewController {
    
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitsTextField: UITextField!
    @IBOutlet weak var ingredientsTable: UITableView!
	@IBOutlet weak var pickUnitsButton: UIButton!
	@IBOutlet weak var pickIngredientsButton: UIButton!
	
	let ingredientsList = ["", "Potato","Tomato", "Onion", "Cabbage", "Cauliflower", "Garlic", "Eggplant", "Cilantro", "Basil", "Spring Onions", "Capsicum", "Black Gram Lentil", "Bengal Gram Lentil", "Mustard Seeds", "Cumin Seeds", "Pepper", "Chilli Powder", "Green Chillies", "Jalapeno", "Lemon", "Salt" , "Oil", "Vegetable Oil", "Canola Oil", "Olive Oil", "Butter", "Ghee", "Cardamom", "Cinnamon", "Clove", "Ginger", "Coriander", "Turmeric", "Garam Masala"]
	
	let unitsList = ["", "tablespoon", "tbsp", "teaspoon", "tsp", "pinch", "cup", "large", "small", "medium", "ounce", "oz", "pint", "litre(s)", "gram(s)", "quart", "dash", "gallon", "pound", "lbs"]
	
	
    private var stepNumber = 1
    var steps: [CookingStep]?
    var stepIngredients = [String]()
    var stepIngredientAmounts = [String]()
    var stepIngredientUnits = [String]()
    var stepImageUploaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ingredientsTable.delegate = self
        ingredientsTable.dataSource = self
        ingredientsTable.estimatedRowHeight = 50
        ingredientsTable.rowHeight = UITableViewAutomaticDimension
        let nibName = UINib(nibName: "IngredientsTableViewCell", bundle: nil)
        ingredientsTable.register(nibName, forCellReuseIdentifier: "IngredientsTableViewCell")
		ingredientsTable.separatorStyle = UITableViewCellSeparatorStyle.none
		
        if steps == nil {
            stepNumber = 1;
            steps = [CookingStep]()
        }
        else {
            stepNumber = (steps?.count)! + 1
        }
		self.title = "Step:\(stepNumber)"
        clearIngregients()
        ingredientsTable.reloadData()
		
		self.hideKeyboardWhenTappedAround()
		pickUnitsButton.layer.cornerRadius = 3
		pickIngredientsButton.layer.cornerRadius = 3
		
//		setupTextFieldAtributes(field: ingredientTextField, string: "Ingredient")
//		setupTextFieldAtributes(field: amountTextField, string: "Amount")
//		setupTextFieldAtributes(field: unitsTextField, string: "Units")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	private func setupTextFieldAtributes(field: UITextField, string: String) {
		let width = CGFloat(2.0)
		// field.textColor = UIColor.lightGray
		let fieldBorder = CALayer()
		fieldBorder.borderColor = UIColor.lightGray.cgColor
		fieldBorder.frame = CGRect(x: 0, y: field.frame.size.height - width, width:  field.frame.size.width, height: field.frame.size.height)
		fieldBorder.borderWidth = width
		field.layer.addSublayer(fieldBorder)
		field.layer.masksToBounds = true
		field.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
	}
	
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func clearIngregients() {
        ingredientTextField.text = ""
        amountTextField.text = ""
        unitsTextField.text = ""
        stepIngredientUnits.removeAll()
        stepIngredientAmounts.removeAll()
        stepIngredients.removeAll()
    }
    
    private func clearIngregientLabels() {
        ingredientTextField.text = ""
        amountTextField.text = ""
        unitsTextField.text = ""
    }

	@IBAction func ingredientPickerClicked(_ sender: UIButton) {
		ActionSheetStringPicker.show(withTitle: "Pick an Ingredient!", rows: ingredientsList, initialSelection: 0, doneBlock: { (picker: ActionSheetStringPicker?, index:Int, value:Any?) in
			print("\(picker)")
			print("\(value)")
			print("\(index)")
			if (index > 0) {
				self.ingredientTextField.text = value as? String
			} else {
				self.ingredientTextField.text = ""
			}
		}, cancel: { ActionStringCancelBlock in
			return
		}, origin: sender.superview!.superview)
	}
	
	@IBAction func unitsPickerClicked(_ sender: UIButton) {
		ActionSheetStringPicker.show(withTitle: "Pick a Unit", rows: unitsList, initialSelection: 0, doneBlock: { (picker: ActionSheetStringPicker?, index:Int, value: Any?) in
			if (index > 0) {
				self.unitsTextField.text = value as? String
			} else {
				self.unitsTextField.text = ""
			}
		}, cancel: { ActionStringCancelBlock in
			return
		}, origin: sender.superview!.superview)
	}
	
	@IBAction func onAddIngredient(_ sender: Any) {
        if let name = ingredientTextField.text {
            let ingredient = name
            stepIngredients.append(ingredient)
            if let amountStr = amountTextField.text {
                stepIngredientAmounts.append(amountStr)
            }
            else {
                print("InvalidAmount")
                stepIngredients.removeLast()
                amountTextField.becomeFirstResponder()
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
    
    @IBAction func onIngredientsNext(_ sender: Any?) {
        let cookingStep = CookingStep()
        cookingStep.ingredients = stepIngredients
        cookingStep.ingredientAmounts = stepIngredientAmounts
        cookingStep.ingredientUnits = stepIngredientUnits
        steps?.append(cookingStep)
        performSegue(withIdentifier: "StepDescriptionSegue", sender: nil)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! AddStepDescriptionViewController
        destVC.steps = steps
    }
}

extension IngredientsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (stepIngredients.count > 0) {
            return stepIngredients.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTable.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell", for: indexPath) as! IngredientsTableViewCell
        cell.customInit(name: stepIngredients[indexPath.row], amount: stepIngredientAmounts[indexPath.row], units: stepIngredientUnits[indexPath.row])
        return cell
    }
}

