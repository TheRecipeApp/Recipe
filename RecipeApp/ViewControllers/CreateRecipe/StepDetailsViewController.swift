//
//  StepDetailsViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/19/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

class StepDetailsViewController: UIViewController {
	@IBOutlet weak var ingredientsTable: UITableView!
	@IBOutlet weak var stepDescription: UITextView!
	@IBOutlet weak var stepImage: UIImageView!
	@IBOutlet weak var stepAudio: UIButton!
	
	var step: CookingStep?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		ingredientsTable.delegate = self
		ingredientsTable.dataSource = self
		ingredientsTable.estimatedRowHeight = 50
		ingredientsTable.rowHeight = UITableViewAutomaticDimension
		let nibName = UINib(nibName: "IngredientsTableViewCell", bundle: nil)
		ingredientsTable.register(nibName, forCellReuseIdentifier: "IngredientsTableViewCell")

        // Do any additional setup after loading the view.
		stepDescription.text = step?.desc
		setupStepImage()
		stepAudio.layer.borderWidth = 1
    }
	
	func setupStepImage() {
		let imageFile = step?.stepImage
		imageFile?.getDataInBackground(block: { (data: Data?, error: Error?) in
			if error == nil {
				if let imageData = data {
					self.stepImage.image = UIImage(data: imageData)
					self.stepImage.contentMode = .scaleAspectFit
				}
			}
		})
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func onAudioPlayTapped(_ sender: Any) {
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

extension StepDetailsViewController : UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (step?.ingredients?.count)!
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell", for: indexPath) as! IngredientsTableViewCell
		cell.ingredientNameLabel.text = step?.ingredients?[indexPath.row].name
		if let amount = step?.ingredientAmounts[indexPath.row] {
			cell.ingredientAmountLabel.text = String("\(amount)")
		}
		cell.ingredientUnitsLabel.text = step?.ingredientUnits[indexPath.row]
		return cell
	}
	
	
}
