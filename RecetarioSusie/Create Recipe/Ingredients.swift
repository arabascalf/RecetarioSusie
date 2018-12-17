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
    var amount: String?
    var measurement: String?
    var ingredient_name: String?
    var recipe_id: Int?
    
    init(id: Int, amount: String, measurement: String, ingredient_name: String, recipe_id: Int) {
        
        self.id = id
        self.amount = amount
        self.measurement = measurement
        self.ingredient_name = ingredient_name
        self.recipe_id = recipe_id
    }
}
