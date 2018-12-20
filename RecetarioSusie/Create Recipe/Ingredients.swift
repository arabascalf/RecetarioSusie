//
//  Ingredients.swift
//  RecetarioSusie
//
//  Created by Aranzza Abascal on 12/16/18.
//  Copyright © 2018 mx.itesm. All rights reserved.
//

import Foundation
import UIKit

class Ingredients {
    
    var id: Int
    var ingredientDescription: String?
    var recipe_id: Int?
    
    init(id: Int, ingredientDescription: String, recipe_id: Int) {
        
        self.id = id
        self.ingredientDescription = ingredientDescription
        self.recipe_id = recipe_id
    }
}
