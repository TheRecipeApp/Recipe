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

class IngredientsViewController: UIViewController {
    
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitsTextField: UITextField!
    @IBOutlet weak var ingredientsTable: UITableView!
    
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
		self.title = "Add Step:\(stepNumber) Ingredients"
        clearIngregients()
        ingredientsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let destVC = segue.destination as! NewRecipeViewController
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
