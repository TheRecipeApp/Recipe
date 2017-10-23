//
//  RecipeBlockView.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/17/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit

class RecipeBlockView: UIView {
    
	@IBOutlet var contentView: UIView!
	@IBOutlet weak private var recipeImage: UIImageView!
	@IBOutlet weak private var imageTag: UILabel!
	@IBOutlet weak private var recipeTitle: UILabel!
	@IBOutlet weak private var createBy: UILabel!
	
    var recipeId: String?
    
	var image: UIImage? {
		get { return recipeImage?.image }
		set { recipeImage.image = newValue }
	}
	
	var imgTag : String? {
		get { return imageTag?.text }
		set { imageTag.text = newValue }
	}
	
	var title: String? {
		get { return recipeTitle?.text }
		set { recipeTitle.text = newValue }
	}
	
	var owner: String? {
		get { return self.owner }
		
		set {
			if let ownerVal = newValue {
				let ownerString = "by @" + ownerVal
				createBy.text = ownerString
			}
		}
	}
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
		let nib = UINib(nibName: "RecipeBlockView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)
		contentView.frame = bounds
		addSubview(contentView)
	}

}
