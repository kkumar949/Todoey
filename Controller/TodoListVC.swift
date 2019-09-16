//
//  ViewController.swift
//  Todoey
//
//  Created by Karan Kumar on 4/9/2019.
//  Copyright © 2019 Bright Blockchain Financial Solutions. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {

    //MARK: - 1. Create item array
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        //gets triggered when category is selected only (so app doesn't crash
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //4.1 Set-up user defaults and keys for user defaults
//    let defaults = UserDefaults.standard
//    let defaults = UserDefaults.standard
//    let itemKey = "TodoListArray"

    //4.1 Replace UserDefaults with Encoder... first find out the file path of the p-list where 'User Items' are being stored. i.e. we create our own plist at the location of the datapath
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //MARK 4.1.1 CoreData - C in CRUD... first define the context from the AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load defaults when view opens up.
//        if let items = defaults.array(forKey: itemKey) as? [Item] {
//            itemArray = items
//        }
        
        //MARK: - 4.3 R in CRUD... Decoderd to load 'defalut' data from items.plist when screen is viewed
        loadItems()
    
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //MARK: - 5.1 Search bar
//        searchBar.delegate = self - done it on Main.storyboard
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
//        print(itemArray[indexPath.row])
        
        //To mark the item selected as a 'checkmark'
        itemArray[indexPath.row].done.toggle()
        
        //MARK: - 4.4 D in CRUD... To delete items that are complete - first remove item from context and ONLY then from array
        //this method deletes straight away... not so nice for user experience
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

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
//            let newItem = Item() - for codable
            
            //MARK: - 4.1.2 C in CRUD... CoreData... cant do let context = AppDelegate.persistentContainer.viewContext so need to greate an object from it...
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            //4.2 Set user default
//            self.defaults.set(self.itemArray, forKey: self.itemKey)
            //MARK: - 4.2 Save - new object of type PropertyListEncoder to encode data (itemArray) into PropertyList
            
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
    
    //MARK 4.2 - Save data
    func saveItems() {
        
        //4.2 Encoder - new object of type PropertyListEncoder to encode data (itemArray) into PropertyList
//        let encoder = PropertyListEncoder()
//
//        //Need to do a do...catch block to catch errors and write the data into the datafilepath we captured earlier... Make sure we go to ItemClass and mark it as Encodable to we can encode it!
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//
//        } catch {
//            print("Error encoding item array... \(error)")
//        }
        
        //MARK: - 4.2 CoreData... C in CRUD
        
        do {
            try context.save()
        } catch {
            print("something went wrong saving context... \(error)")
        }
        
        //reload tableview to show item
        self.tableView.reloadData()
    }
    
    //MARK 4.3 - Load data.., make sure to go to ItemCalss and mark it as Decodable
    //MARK: - 4.3 R in CRUD... Load items
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil) {

//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("something went wrong... \(error)")
//            }
//        }
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate //i.e. predicate is nil
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context; \(error)")
        }
        tableView.reloadData()
    }


}

extension TodoListVC: UISearchBarDelegate {
    
    //MARK: - 5.2 Searchbar delegates
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Query the database for what the user is looking for
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //i.e. looks for searchBar.text in title
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context; \(error)")
//        }
//
//        tableView.reloadData()
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
