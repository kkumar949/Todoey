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
    
    
    //4.1 Set-up user defaults and keys for user defaults
//    let defaults = UserDefaults.standard
    //MARK: - 4.1 Replace UserDefaults with Encoder... first find out the file path of the p-list where 'User Items' are being stored. i.e. we create our own plist at the location of the datapath
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
 //   let defaults = UserDefaults.standard
    let itemKey = "TodoListArray"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load defaults when view opens up.
//        if let items = defaults.array(forKey: itemKey) as? [Item] {
//            itemArray = items
//        }
        
        //MARK: - 4.3 Decoderd to load 'defalut' data from items.plist when screen is viewed
        loadItems()
        
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
        saveItems()
        
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
            
            //4.2 Set user default
//            self.defaults.set(self.itemArray, forKey: self.itemKey)
            //MARK: - 4.2 Save using Encoder - new object of type PropertyListEncoder to encode data (itemArray) into PropertyList
            self.saveItems()

        }
        
        alert.addTextField { (alertTextField) in
            //set-up alert text field
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField

        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK 4.2 - Save data using the encoder
    func saveItems() {
        
        //MARK: - 4.2 Encoder - new object of type PropertyListEncoder to encode data (itemArray) into PropertyList
        let encoder = PropertyListEncoder()
        
        //Need to do a do...catch block to catch errors and write the data into the datafilepath we captured earlier... Make sure we go to ItemClass and mark it as Encodable to we can encode it!
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("Error encoding item array... \(error)")
        }
        
        //reload tableview to show item
        self.tableView.reloadData()
    }
    
    //MARK 4.3 - Load data.., make sure to go to ItemCalss and mark it as Decodable
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("something went wrong... \(error)")
            }
        }
    }

}

