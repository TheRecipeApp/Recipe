//
//  Ingredient.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/12/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Parse

class Ingredient: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "Ingredient"
	}
	
	static var ingredientList = ["All-purpose flour","Almond Extract","Almond Flour","Almonds","Apple","Apple cider","Apricots","Artichoke Hearts","Asafoetida","Baking powder","Baking soda","Barley","Basil","Bay Leaves","Beans","Bengal Gram Daal","Black Beans","Black Eyed Peas","Black Olives","Black Pepper","Black gram Daal","Blackberries","Breadcrumbs","Broccoli","Brown sugar","Butter","Cabbage","Cannellini Beans","Canola Oil","Capsicum","Cashew Nut","Cauliflower","Cayenne Pepper","Cheddar cheese","Chia Seeds","Chicken Broth","Chickpeas","Chili powder","Cinnamon","Cloves","Cocoa powder","Coconut Flour","Coconut Oil","Corn tortillas","Cornstarch","Couscous","Cream of tartar","Crushed Red Pepper","Cumin","Curry powder","Dessicated Coconut","Dried Red Chillies","Edamame","Eggplant","Eggs","Fennel","Feta Cheese","Flour","Garam Masala","Garbanzo Beans","Garlic","Gingelly Oil","Granulated sugar","Green Gram Daal","Ground Coriander","Honey","Italian Seasoning","Jack Cheese","Jalapeno","Ketchup","Kidney Beans","Maple Extract","Maple Syrup","Mayonnaise","Milk","Millet","Mint","Mozzarella Cheese","Mustard seeds","Nutmeg","Nuts","Olive oil","Onion","Orange","Orange Extract","Orange Zest","Oregano","Panko","Paprika","Parmesan Cheese","Parsley","Peaches","Peanut butter","Peanut Oil","Peanuts","Peas","Pecans","Pepper","Pigeon Peas split","Pink Lentil ","Plain yogurt","Potato","Preserves or jelly","Quinoa","Raisins","Red Kidney Beans (Rajma)","Red Wine","Rice","Rice Flour","Rolled oats","Rosemary","Rum","Salt","Sesame Seeds","Soy Sauce","Spinach","Strawberries","Sun-dried Tomatoes","Sunflower seeds","Tamarind paste","Thyme","Tomato","Tomato paste","Tuna fish","Turmeric","Vanilla Extract","Vegetable Broth","Vegetable Oil","Vinegar","Wheat Pasta","White Pasta","Worcestershire sauce"]
	static var ingredientUnits = ["teaspoon (tsp)","tablespoon (tbl,tbs,tbsp)","fluid ounce (fl oz)","gill (1/2 cup)","cup","pint (pt,fl pt)","quart (qt,fl qt)","gallon (gal)","ml (milliliter,millilitre,cc)","l (liter,litre)","dl (deciliter,decilitre)","pound (lb,#)","ounce (oz)","mg (milligram,milligramme)","gm (g, gram,gramme)","kg (kilogram,kilogramme)","mm (millimeter,millimetre)","cm (centimeter,centimetre)","m (meter,metre)","inch (in)","meter (m)","cubic meter (m3)"]
	
	@NSManaged var name: String
	@NSManaged var image: PFFile?
	@NSManaged var calories: String?
	
	override init() {
		super.init()
	}	
}
