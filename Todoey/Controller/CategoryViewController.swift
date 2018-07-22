//
//  CategoryViewController.swift
//  Todoey
//
//  Created by OLUNUGA Mayowa on 22/07/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    lazy var realm = try! Realm()
    var categoryItems : Results<Category>?
    
    var selectedRow :Int?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //MARK: tableView delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItemCell", for: indexPath)
        cell.textLabel?.text = categoryItems?[indexPath.row].name ?? "Category not available"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        performSegue(withIdentifier: "goToCategoryItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCategoryItem"{
            let itemCatVC = segue.destination as! TodoListViewController
            itemCatVC.selectedCategory = categoryItems?[selectedRow!]
        }
    }
    
    

    
    //MARK: data source methods
    func loadData(){
         categoryItems = realm.objects(Category.self)
         tableView.reloadData()
    }
    
    func saveData(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
            tableView.reloadData()
        }catch{
            print("could not save data \(error)")
        }
    }
    
    
    //MARK:- add button pressed method
 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var mTextField = UITextField()
        let alert = UIAlertController(title: "New Todo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let category = Category()
            category.name = mTextField.text!
            self.saveData(category: category)
        }
        alert.addTextField { (textField) in
            mTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
