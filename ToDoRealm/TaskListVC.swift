//
//  TaskListVC.swift
//  ToDoRealm
//
//  Created by Ashley Ng on 9/4/17.
//  Copyright © 2017 Ashley Ng. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListVC: UITableViewController {
    
    var selectedList: TaskList!
    var openTasks: Results<Task>!
    var completedTasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "taskCell")
        readTasksAndUpdateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Open Tasks" : "Closed Tasks"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? openTasks.count : completedTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskCell {
            let item = indexPath.section == 0 ? openTasks[indexPath.row] : completedTasks[indexPath.row]
            cell.configureCell(taskName: item.name)
            return cell
        }
        return TaskCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = indexPath.section == 0 ? openTasks[indexPath.row] : completedTasks[indexPath.row]
        try! realm.write {
            item.isCompleted = !item.isCompleted
        }
        readTasksAndUpdateUI()
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        displayAlertToAddTask()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func readTasksAndUpdateUI() {
        completedTasks = selectedList.tasks.filter("isCompleted = true")
        openTasks = selectedList.tasks.filter("isCompleted = false")
        tableView.reloadData()
    }
    
    private func displayAlertToAddTask(task: TaskList? = nil) {
        let alertController = UIAlertController(title: "Add Task", message: "Enter the name for the task", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        let createAction = UIAlertAction(title: "Done", style: .default) { [weak self] (alert) in
            guard let taskName = alertController.textFields?.first?.text, let `self` = self else { return }
            
            if let list = task {
                try! realm.write {
                    list.name = taskName
                    self.readTasksAndUpdateUI()
                }
            } else {
                let newTask = Task()
                newTask.name = taskName
                
                try! realm.write({ () -> Void in
                    self.selectedList.tasks.append(newTask)
                    self.readTasksAndUpdateUI()
                })
            }
        }
        alertController.addAction(createAction)
        self.present(alertController, animated: true, completion: nil)
    }


}
