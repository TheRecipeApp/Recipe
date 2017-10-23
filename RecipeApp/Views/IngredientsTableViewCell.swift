//
//  IngredientsTableViewCell.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/19/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {
	@IBOutlet weak var ingredientNameLabel: UILabel!
	@IBOutlet weak var ingredientAmountLabel: UILabel!
	@IBOutlet weak var ingredientUnitsLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func customInit(name: String, amount: Float, units: String) {
		ingredientNameLabel.text = name + ": "
		ingredientAmountLabel.text = String("\(amount)")
		ingredientUnitsLabel.text = "(" + units + ")"
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		ingredientNameLabel.text = ""
		ingredientAmountLabel.text = ""
		ingredientUnitsLabel.text = ""
	}
}
