//
//  RecipeStepCell.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/19/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

class RecipeStepCell: UITableViewCell {

	@IBOutlet weak var stepDescriptionView: UIView!
	@IBOutlet weak var stepNumberView: UIView!
	@IBOutlet weak var stepNumberLabel: UILabel!
	@IBOutlet weak var stepDescriptionLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
		stepNumberLabel.layer.borderWidth = 1
		stepDescriptionLabel.layer.borderWidth = 1
    }

	override func prepareForReuse() {
		super.prepareForReuse()
		stepNumberLabel.text = ""
		stepDescriptionLabel.text = ""
	}
}
