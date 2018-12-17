//
//  IngredientsCell.swift
//  RecetarioSusie
//
//  Created by Aranzza Abascal on 12/16/18.
//  Copyright © 2018 mx.itesm. All rights reserved.
//

import UIKit

class IngredientsCell: UITableViewCell {

    @IBOutlet weak var ingredientDescriptionLabel: UILabel!
    
    func setIngredientText(ingredients: Ingredients) {
        
        let ingredientString = "\(ingredients.amount ?? " ") \(ingredients.measurement ?? " ") \(ingredients.ingredient_name ?? " ")"
        ingredientDescriptionLabel.text = ingredientString
    }
}
