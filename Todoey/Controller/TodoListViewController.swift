//
//  ViewController.swift
//  Todoey
//
//  Created by OLUNUGA Mayowa on 21/07/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import UIKit




class TodoListViewController: UITableViewController {
    
    var todoItemArray: [Item] = [Item]()
    let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let item = Item(title: "Find mark")
        todoItemArray.append(item)
//      if let items = UserDefaults.standard.array(forKey: "TodoItemArray") as? [Item]{
//            todoItemArray = items
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK- tableView setup section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        cell.textLabel?.text = todoItemArray[indexPath.row].title
        let item : Item = todoItemArray[indexPath.row]
        cell.accessoryType = item.isDone ? .checkmark : .none
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
        todoItemArray[indexPath.row].isDone = !todoItemArray[indexPath.row].isDone
        tableView.reloadData()
    }
    
    //MARK - add new item section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var mTexField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item : Item  = Item(title: mTexField.text!)
            self.todoItemArray.append(item)
           // self.defaults.set(self.todoItemArray, forKey: "TodoItemArray")
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
    

}

