//
//  ViewController.swift
//  ToDoRealm
//
//  Created by Ashley Ng on 9/4/17.
//  Copyright © 2017 Ashley Ng. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UITableViewController {
    
    private var taskLists: Results<TaskList> {
        return realm.objects(TaskList.self)
    }
    
    private var isEditingMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        realm = try! Realm()
        
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        readListAndUpdateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? ListCell {
            let item = taskLists[indexPath.row]
            cell.configureCell(listName: item.name, numberOfTasks: item.tasks.count)
            return cell
        }
        return ListCell()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (deleteAction, indexPath) -> Void in
            guard let `self` = self else { return }
            
            let listToBeDeleted = self.taskLists[indexPath.row]
            try! realm.write { () in
                realm.delete(listToBeDeleted)
                self.readListAndUpdateUI()
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] (editAction, indexPath) in
            guard let `self` = self else { return }
            let listToBeUpdated = self.taskLists[indexPath.row]
            self.displayAlertToAddList(list: listToBeUpdated)
        }
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listToTasksSegue", sender: self)
    }


    @IBAction func addListTapped(_ sender: Any) {
        displayAlertToAddList()
    }
    
    @IBAction func editListTapped(_ sender: Any) {
        isEditingMode = !isEditingMode
        tableView.setEditing(isEditingMode, animated: true)
    }
    
    private func readListAndUpdateUI() {
        tableView.reloadData()
    }
    
    private func displayAlertToAddList(list: TaskList? = nil) {
        let alertController = UIAlertController(title: "Add List", message: "Enter the name for the list", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        let createAction = UIAlertAction(title: "Done", style: .default) { [weak self] (alert) in
            guard let listName = alertController.textFields?.first?.text, let `self` = self else { return }
            
            if let list = list {
                try! realm.write {
                    list.name = listName
                    self.readListAndUpdateUI()
                }
            } else {
                let newList = TaskList()
                newList.name = listName
                
                try! realm.write({ () -> Void in
                    realm.add(newList)
                    self.readListAndUpdateUI()
                })
            }
        }
        alertController.addAction(createAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToTasksSegue",
            let nextVC = segue.destination as? TaskListVC,
            let indexPath = tableView.indexPathForSelectedRow {
            let selectedItem = taskLists[indexPath.row]
            nextVC.selectedList = selectedItem
            nextVC.title = selectedItem.name
        }
    }
}

