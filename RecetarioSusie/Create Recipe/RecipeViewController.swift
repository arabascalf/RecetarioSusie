//
//  RecipeViewController.swift
//  RecetarioSusie
//
//  Created by Aranzza Abascal on 12/16/18.
//  Copyright © 2018 mx.itesm. All rights reserved.
//

import UIKit
import SQLite3

class RecipeViewController: UIViewController {
    
    var recipe_id: Int? = nil
    var ingredientsList = [Ingredients]()
    var ingredientToAdd = [Ingredients]()
    let measurementArray = ["N/A", "Pizca", "Cucharadita", "Cucharada", "Taza", "Mililitros", "Gramos"]
    
    var db: OpaquePointer?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeNameLabel: UITextField!
    @IBOutlet weak var chefRecipeLabel: UITextField!
    @IBOutlet weak var servicesTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var methodTextView: UITextView!
    @IBOutlet weak var measurementTypes: UITextField!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var measurementTextField: UITextField!
    @IBOutlet weak var ingredientNameTextField: UITextField!
    
    private var measurementPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customMeasurementPicker()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("RecipesDB.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Ingredients (id INTEGER PRIMARY KEY AUTOINCREMENT, amount TEXT, measurement TEXT, ingredient_name TEXT, recipeId INTEGER, FOREIGN KEY(recipeId) REFERENCES Recipes(id))", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(errmsg)")
        }
    }
    
    @IBAction func saveRecipe(_ sender: Any) {

        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("RecipesDB.sqlite")
        
        // open database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        let recipe = recipeNameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let chef = chefRecipeLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let services = Int((servicesTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
        let notes = notesTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let method = methodTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let queryString = "INSERT INTO Recipes (recipe_name,chef_name,services,notes,method) VALUES ("
        let recipeNameQuery = "\"\(recipe ?? " ")\""
        let chefNameQuery = "\"\(chef ?? " ")\""
        let servicesQuery = "\(services ?? 0)"
        let notesQuery = "\"\(notes ?? " ")\""
        let methodQuery = "\"\(method ?? " ")\""
        let queryStringComplete = "\(queryString) \(recipeNameQuery), \(chefNameQuery), \(servicesQuery), \(notesQuery), \(methodQuery));"
        print(queryStringComplete)
        
        if sqlite3_exec(db, queryStringComplete, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error insertint value into table: \(errmsg)")
        }
        
        recipeNameLabel.text = ""
        chefRecipeLabel.text = ""
        servicesTextField.text = ""
        notesTextView.text = ""
        methodTextView.text = ""
        
        print("Recipe saved successfully")
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
}


extension RecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func customMeasurementPicker() {
        measurementPicker = UIPickerView()
        measurementTypes.inputView = measurementPicker
        measurementPicker.delegate = self
        measurementPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return measurementArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return measurementArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        measurementTypes.text = measurementArray[row]
    }
}
