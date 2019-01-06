//
//  ViewController.swift
//  Todoey
//
//  Created by OLUNUGA Mayowa on 21/07/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    lazy var realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         title = selectedCategory!.name
        guard let color = selectedCategory?.color else {
            do {fatalError("failed")}
        }
         updateNavBarColor(withHexColor: color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       let originalColor =  "1D9bF6"
       updateNavBarColor(withHexColor: originalColor)
    }
    
    
    func updateNavBarColor(withHexColor colorHexCode: String) {
        
        guard let color = UIColor(hexString: colorHexCode) else {
            do {fatalError("failed")}
        }
        if let navBar = navigationController?.navigationBar{
            navBar.barTintColor = color
            searchBar.barTintColor = color
            navBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            
            if #available(iOS 11.0, *) {
                navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)]
            } else {
                // Fallback on earlier versions
            }
           
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: tableView setup section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item : Item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory?.color).darken(byPercentage: (CGFloat(indexPath.row))/(CGFloat(todoItems!.count))) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
            
        }else{
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let todoItem = todoItems?[indexPath.row] {
            do{
           try realm.write {
                todoItem.done = !todoItem.done
                }}catch{
                    print("Error updating item \(error)")
            }
        }
         tableView.deselectRow(at: indexPath, animated: true)
         tableView.reloadData()
    }
    
    //MARK: add new item section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var mTexField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory{
                do{
                try self.realm.write {
                    let item : Item  = Item()
                    item.title = mTexField.text!
                    item.dateCreated = Date()
                    currentCategory.items.append(item)
                    }
                    
                }catch{
                    print("Error \(error)")
                }
            }
            
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
    
    func loadItems(){
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
    }
    
    
    override func deletItem(at indexPath: IndexPath) {
        
        if let itemTodDelete = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(itemTodDelete)
                }
                
            }catch{
                print("Could not delete item")
            }
        }
        
        
    }
}

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

