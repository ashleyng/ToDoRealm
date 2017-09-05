//
//  TaskCell.swift
//  ToDoRealm
//
//  Created by Ashley Ng on 9/4/17.
//  Copyright © 2017 Ashley Ng. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(taskName: String) {
        self.taskName.text = taskName
    }

}
