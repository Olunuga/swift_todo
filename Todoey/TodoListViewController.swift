//
//  ViewController.swift
//  Todoey
//
//  Created by OLUNUGA Mayowa on 21/07/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import UIKit




class TodoListViewController: UITableViewController {
    
    var todoItemArray = ["Find Mark", "Read book", "Go home", "Make money"]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK- tableView setup section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        cell.textLabel?.text = todoItemArray[indexPath.row]
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
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - add new item section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var mTexField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.todoItemArray.append(mTexField.text!)
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

