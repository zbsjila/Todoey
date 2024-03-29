//
//  ViewController.swift
//  Todoey
//
//  Created by Bosheng Zhang on 10/17/19.
//  Copyright © 2019 BZ. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
//    var itemArray = ["Find Mike", "Buy eggs", "Destroy Demogorgon"]
    var itemArray = [Item]();
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//    print("dataFilePath = \(dataFilePath)")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        let newItem = Item(withTitle: "Find Mike");
        itemArray.append(newItem)
        let newItem2 = Item(withTitle: "Buy eggs")
        itemArray.append(newItem2)
        let newItem3 = Item(withTitle: "Destroy Demogorgon")
        itemArray.append(newItem3)

//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items;
//        }
        loadItems();
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row];
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark: .none;
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done;
        self.saveItems()
        tableView.reloadData();
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - addButtonPressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField;
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(Item(withTitle: textField.text!));
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
            
            self.tableView.reloadData();
            print("Success")
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            print(" data.write to: \(dataFilePath!)")
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder();
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array. \(error)")
            }
        }
    }
}

