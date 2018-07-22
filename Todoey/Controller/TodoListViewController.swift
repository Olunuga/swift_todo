//
//  ViewController.swift
//  Todoey
//
//  Created by OLUNUGA Mayowa on 21/07/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import UIKit
import CoreData



class TodoListViewController: UITableViewController {
    
    var todoItemArray: [Item] = [Item]()
    let defaults = UserDefaults.standard
    var  directoryfilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var fileDir : URL?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //fileDir = directoryfilePath.appendingPathComponent("Items.plist")
        //loadItems()
        
       // print(categoryUniqueID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: tableView setup section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        cell.textLabel?.text = todoItemArray[indexPath.row].title
        let item : Item = todoItemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItemArray.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(todoItemArray[indexPath.row])
         tableView.deselectRow(at: indexPath, animated: true)
        todoItemArray[indexPath.row].done = !todoItemArray[indexPath.row].done
        tableView.reloadData()
    }
    
    //MARK: add new item section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var mTexField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item : Item  = Item(context: self.context)
            item.title = mTexField.text!
            item.done = false
            item.parentCategory = self.selectedCategory
            
            self.todoItemArray.append(item)
            self.saveItem()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
             textField.placeholder = "Create new item"
             mTexField = textField
        }
        present(alert, animated: true) {
            
            
        }
    }
    
    func saveItem(){
        do{
           try context.save()
        }catch{
           print("error saving data with\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), and predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let searchPredicate : NSPredicate  = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,searchPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        do{
            todoItemArray = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print("Could not fetch from due to error\(error)")
        }
    }
}

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, and: predicate)
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

