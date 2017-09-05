//
//  Task.swift
//  ToDoRealm
//
//  Created by Ashley Ng on 9/4/17.
//  Copyright © 2017 Ashley Ng. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var notes = ""
    dynamic var isCompleted = false
}

class TaskList: Object {
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    let tasks = List<Task>()
}
