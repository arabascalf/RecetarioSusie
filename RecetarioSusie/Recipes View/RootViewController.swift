//
//  RootViewController.swift
//  RecetarioSusie
//
//  Created by Aranzza Abascal on 12/16/18.
//  Copyright © 2018 mx.itesm. All rights reserved.
//

import UIKit
import SQLite3

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var db: OpaquePointer?
    @IBOutlet weak var tableView: UITableView!
    var textFieldName: String = "brownies"
    var textFieldChef: String = "Tatá"
    var recipesList = [Recipe]()
    var idsList: [Int] = []
    var namesList: [String] = []
    var recipe_id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("RecipesDB.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Recipes (id INTEGER PRIMARY KEY AUTOINCREMENT, recipe_name TEXT, chef_name TEXT, services TEXT, notes TEXT, method TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(errmsg)")
        }
        
        recipe_id = nil
        readValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        readValues()
    }
    
    func readValues(){
        
        //first empty the list of heroes
        recipesList.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM Recipes"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let recipe_name = String(cString: sqlite3_column_text(stmt, 1))
            let chef_name = String(cString: sqlite3_column_text(stmt, 2))
            let services = sqlite3_column_int(stmt, 3)
            let notes = String(cString: sqlite3_column_text(stmt, 4))
            let method = String(cString: sqlite3_column_text(stmt, 5))
            
            //adding values to list
            recipesList.append(Recipe(image: #imageLiteral(resourceName: "recipecard"), id: Int(id), name: String(recipe_name), chef: String(chef_name), services: Int(services), notes: String(notes), method: String(method)))
        }
        
        self.tableView.reloadData()
    }
    
    func deleteRecipe(recipe: Recipe) {
        let queryString = "DELETE FROM Recipes WHERE id=?"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 1, (Int32(recipe.id as Int))) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding id: \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting recipe: \(errmsg)")
            return
        }
        
        print("Recipe deleted successfully")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as! RecipeCell
        let recipe: Recipe
        recipe = recipesList[indexPath.row]
        cell.setImageView(image: recipe.image!)
        cell.setRecipeName(nameText: recipe.name!)
        cell.setRecipeChef(chefText: recipe.chef!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipe_id = indexPath.row
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = segue.destination as! RecipeViewController
        nextView.recipe_id = recipe_id!
    }*/
}
