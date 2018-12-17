//
//  Recipe.swift
//  RecetarioSusie
//
//  Created by Aranzza Abascal on 12/16/18.
//  Copyright © 2018 mx.itesm. All rights reserved.
//

import Foundation
import UIKit

class Recipe {
    var id: Int
    var name: String?
    var chef: String?
    var services: Int?
    var notes: String?
    var method: String?
    var image: UIImage?
    
    init(image: UIImage, id: Int, name: String?, chef: String?, services: Int?, notes: String?, method: String?){
        self.image = image
        self.id = id
        self.name = name
        self.chef = chef
        self.services = services
        self.notes = notes
        self.method = method
    }
}
