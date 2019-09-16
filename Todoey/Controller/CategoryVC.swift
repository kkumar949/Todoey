//
//  CategoryVC.swift
//  Todoey
//
//  Created by Karan Kumar on 4/9/2019.
//  Copyright © 2019 Bright Blockchain Financial Solutions. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryVC: UITableViewController {
    
    //REALM Step 4: declare instance of Realm() force unwrapping is ok.
    let realm = try! Realm()
    
    //REALM Step 5.3.1: change categorieas to type Results with a lot of Category type objects in it
    var categories : Results<Category>?
    
    //    var categories = [Category]()
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    
    @IBAction func addBTPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Name of Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
//            let newCategory = Category(context: self.context)
            //REALM Step 5.1 create category
            let newCategory = Category()
            newCategory.name = textField.text!
//            self.categories.append(newCategory) //dont need to append as it realm automatically does it
//            self.saveCategories()
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadCategories() {

//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("tableview did not load... \(error)")
//        }
        
//      REALM Step 5.3.2: R in CRUD
        categories = realm.objects(Category.self)
        tableView.reloadData()

    }
    
    //MARK: - Data manipulation methods
    //REALM Step 5.2 C in CRUD: save realm (replace func saveCategories() with func save(category: Category) and add realm.write
    func save(category: Category) {
        do {
//            try context.save()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("categories did not save... \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Table view datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //i.e. if categories.count = nil, then return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        return cell
        
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //MARK: - Segue to TodoListVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}
