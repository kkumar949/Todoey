//
//  ViewController.swift
//  Todoey
//
//  Created by Karan Kumar on 4/9/2019.
//  Copyright © 2019 Bright Blockchain Financial Solutions. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {

    //MARK: - 1. Create item array
    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
    
    //MARK: - 4.1 Set-up user defaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - 4.3 Load defaults when view opens up.
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    //MARK: - 2.1 Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK: - 2.2 Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //give cell a checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //dont keep cell row coloured grey - turn it back into white after it's selected
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - 3. Add New Item to todolist
    @IBAction func addBTPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user click add item BT on UI Alert
            self.itemArray.append(textField.text!)
            
            //MARK: - 4.2 Set user default
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //reload tableview to show item
            self.tableView.reloadData()

        }
        
        alert.addTextField { (alertTextField) in
            //set-up alert text field
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            print("Now")
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    

}

