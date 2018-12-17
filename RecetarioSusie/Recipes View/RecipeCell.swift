//
//  RecipeCell.swift
//  RecetarioSusie
//
//  Created by Aranzza Abascal on 12/16/18.
//  Copyright © 2018 mx.itesm. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeCardBackground: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var chefRecipeLabel: UILabel!
    
    func setImageView(image: UIImage) {
        recipeCardBackground.image = image
    }
    
    func setRecipeName(nameText: String) {
        recipeNameLabel.text = nameText
    }
    
    func setRecipeChef(chefText: String) {
        chefRecipeLabel.text = chefText
    }
}
