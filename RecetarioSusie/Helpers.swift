//
//  Helpers.swift
//  RecetarioSusie
//
//  Created by Aranzza Abascal on 12/20/18.
//  Copyright © 2018 mx.itesm. All rights reserved.
//

import UIKit

// Extension of RootViewController to custom the table view
extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Function to add rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }
    
    // Function to custom the prototype cell in each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as! RecipeCell
        let recipe: Recipe
        recipe = recipesList[indexPath.row]
        cell.setImageView(image: recipe.image!)
        cell.setRecipeName(nameText: recipe.name!)
        cell.setRecipeChef(chefText: recipe.chef!)
        return cell
    }
    
    // Function to allow the user to edit the row (Delete)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Function to delete the row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let recipe: Recipe
            recipe = recipesList[indexPath.row]
            deleteRecipe(recipe: recipe)
            
            recipesList.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    // Function to know which row the user will edit
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipe_id = indexPath.row
    }
}

// Extension of RecipeViewController to custom the UIPickerView of measurement types
extension RecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Function to asign deletegate and data source
    func customMeasurementPicker() {
        measurementPicker = UIPickerView()
        measurementTypes.inputView = measurementPicker
        measurementPicker.delegate = self
        measurementPicker.dataSource = self
    }
    
    // Function to add the components on the pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Function to add the title of the pickerview
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return measurementArray[row]
    }
    
    // Function to add the number of rows on the pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return measurementArray.count
    }
    
    // Function to modify textfield depending on the pickerview
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        measurementTypes.text = measurementArray[row]
    }
}

// Extension of RecipeViewController to custom the tableview
extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Function to add the number of rows on the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientToAdd.count
    }
    
    // Function to custom the prototype cell on each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredientDescription = ingredientToAdd[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell") as! IngredientsCell
        cell.ingredientDescriptionLabel.text = ingredientDescription
        
        return cell
    }
    
    // Function to allow the user to edit the row (Delete)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Function to delete the row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            ingredientToAdd.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
