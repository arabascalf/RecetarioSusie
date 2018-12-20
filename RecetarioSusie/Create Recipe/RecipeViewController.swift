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
    var ingredientToAdd: [String] = []
    let measurementArray = ["N/A", "Pizca(s)", "Cucharadita(s)", "Cucharada(s)", "Taza(s)", "Mililitro(s)", "Gramo(s)"]
    var id = 0
    
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
    
    var measurementPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customMeasurementPicker()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("RecipesDB.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
    }
    
    @IBAction func saveRecipe(_ sender: Any) {

        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("RecipesDB.sqlite")
        
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
        insertIngredients()
    }
    
    func insertIngredients(){
        
        getLastId()
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Ingredients (id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, FOREIGN KEY(recipeId) REFERENCES Recipes(id))", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(errmsg)")
        }
        
        let queryString = "INSERT INTO Ingredients (description, recipeId) VALUES ("
        
        for ingredient in ingredientToAdd {
            let queryStringComplete = "\(queryString) \"\(ingredient)\", \(id));"
            
            print(queryStringComplete)
            
            if sqlite3_exec(db, queryStringComplete, nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error insert ingredient value into table: \(errmsg)")
            }
        }
        
        print("Ingredient saved successfully")
    }
    
    func getLastId() {
        
        let queryString = "SELECT id FROM Recipes ORDER BY id DESC LIMIT 1"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            id = Int(sqlite3_column_int(stmt, 0))
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        ingredientToAdd.append("\(amountTextField.text ?? " ") \(measurementTextField.text ?? " ") \(ingredientNameTextField.text ?? " ")")
        
        let indexPath = IndexPath(row: ingredientToAdd.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        amountTextField.text = ""
        measurementTextField.text = ""
        ingredientNameTextField.text = ""
    }
}
