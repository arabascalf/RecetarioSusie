//
//  RootViewController.swift
//  RecetarioSusie
//
//  Created by Aranzza Abascal on 12/16/18.
//  Copyright © 2018 mx.itesm. All rights reserved.
//

import UIKit
import SQLite3

class RootViewController: UIViewController {
    
    // Pointer to access to the database
    var db: OpaquePointer?
    
    // Array to store all the recipes on the database and show them on screen
    var recipesList = [Recipe]()
    
    // Variable to know if the user will create or edit
    var recipe_id: Int?
    
    // TableView on screen to show the recipes on the database
    @IBOutlet weak var tableView: UITableView!
    
    // First function to be called
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Directory where the database will be created
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("RecipesDB.sqlite")
        
        // Validation to open the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        
        // Table Recipes is created
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Recipes (id INTEGER PRIMARY KEY AUTOINCREMENT, recipe_name TEXT, chef_name TEXT, services TEXT, notes TEXT, method TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(errmsg)")
        }
        
        // Table Ingredients is created
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Ingredients (id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, recipeId INTEGER, FOREIGN KEY(recipeId) REFERENCES Recipes(id))", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(errmsg)")
        }
        
        // Inicialization of variable
        recipe_id = nil
        
        // Call to function to show all the recipes on the database
        readValues()
    }
    
    // Function to get all recipes on the database
    func readValues(){
        
        // Empty the list of recipes
        recipesList.removeAll()
        
        // Select query
        let queryString = "SELECT * FROM Recipes"
        
        // Statement pointer
        var stmt:OpaquePointer?
        
        // Validation to prepare the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert: \(errmsg)")
            return
        }
        
        // Traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let recipe_name = String(cString: sqlite3_column_text(stmt, 1))
            let chef_name = String(cString: sqlite3_column_text(stmt, 2))
            let services = sqlite3_column_int(stmt, 3)
            let notes = String(cString: sqlite3_column_text(stmt, 4))
            let method = String(cString: sqlite3_column_text(stmt, 5))
            
            // Adding values to list
            recipesList.append(Recipe(image: #imageLiteral(resourceName: "recipecard"), id: Int(id), name: String(recipe_name), chef: String(chef_name), services: Int(services), notes: String(notes), method: String(method)))
        }
        
        // Show the recipes on screen
        self.tableView.reloadData()
    }
    
    // Function to delete recipes
    func deleteRecipe(recipe: Recipe) {
        
        // Call to delete ingredients
        deleteIngredients(recipe: recipe)
        
        // Delete query
        let queryString = "DELETE FROM Recipes WHERE id=?"
        
        // Statement pointer
        var stmt:OpaquePointer?
        
        // Validation to prepare the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing delete: \(errmsg)")
            return
        }
        
        // Validation to pass id as parameter
        if sqlite3_bind_int(stmt, 1, (Int32(recipe.id as Int))) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding id: \(errmsg)")
            return
        }
        
        // Validation to execute the query
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting recipe: \(errmsg)")
            return
        }
    }

    // Function to delete ingredients which have recipe.id as foreign key (Cascade delete)
    func deleteIngredients(recipe: Recipe) {
        
        // Delete query
        let queryString = "DELETE FROM Ingredients WHERE recipeId=?"
        
        // Statement pointer
        var stmt:OpaquePointer?
        
        // Validation to prepare the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing delete: \(errmsg)")
            return
        }
        
        // Validation to pass id as parameter
        if sqlite3_bind_int(stmt, 1, (Int32(recipe.id as Int))) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding id: \(errmsg)")
            return
        }
        
        // Validation to execute the query
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure deleting ingredients: \(errmsg)")
            return
        }
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = segue.destination as! RecipeViewController
        nextView.recipe_id = recipe_id!
    }*/
}
