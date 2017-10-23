//
//  CookingStepView.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/22/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

class CookingStepView: UIView {

	@IBOutlet var contentView: UIView!
	@IBOutlet weak var ingredientsTable: UITableView!
	@IBOutlet weak var stepImage: UIImageView!
	@IBOutlet weak var stepAudioButton: UIButton!
	@IBOutlet weak var stepDescription: UILabel!
	
	/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	/*
	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func draw(_ rect: CGRect) {
	// Drawing code
	}
	*/
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initSubviews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initSubviews()
	}
	
	func initSubviews() {
		let nib = UINib(nibName: "CookingStepView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)
		contentView.frame = bounds
		addSubview(contentView)
		stepImage.layer.borderWidth = 1
		stepAudioButton.layer.borderWidth = 1
	}
	
	func customInit(cookingStep: CookingStep) {
	}
}
