//
//  RecipeCollectionViewCell.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/25/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {

    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var categoryLabel: UILabelCategory!
    @IBOutlet var createdByLabel: UILabel!
    @IBOutlet var recipeTitle: UILabel!

    var recipeId: String?
    var recipe: Recipe?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.cornerRadius = 5
        self.layer.cornerRadius = 5
    }

}
