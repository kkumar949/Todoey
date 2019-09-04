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
    var itemArray = [Item]()
        
    //MARK: - 4.1 Set-up user defaults and keys for user defaults
    let defaults = UserDefaults.standard
    let itemKey = "TodoListArray"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "But Eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Save the world"
        itemArray.append(newItem3)
        
        //MARK: - 4.3 Load defaults when view opens up.
        if let items = defaults.array(forKey: itemKey) as? [Item] {
            itemArray = items
        }
        
    }
    
    //MARK: - 2.1 Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //give cell a checkmark
        cell.accessoryType = item.done ? .checkmark : .none
//        the above (ternary operator) is same as the below
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
    //MARK: - 2.2 Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done.toggle()
        
        tableView.reloadData()
        
        //dont keep cell row coloured grey - turn it back into white after it's selected
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - 3. Add New Item to todolist
    @IBAction func addBTPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen when user click add item BT on UI Alert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //MARK: - 4.2 Set user default
            self.defaults.set(self.itemArray, forKey: self.itemKey)
            
            //reload tableview to show item
            self.tableView.reloadData()

        }
        
        alert.addTextField { (alertTextField) in
            //set-up alert text field
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField

        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    

}

