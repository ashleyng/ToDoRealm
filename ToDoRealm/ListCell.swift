//
//  ListCell.swift
//  ToDoRealm
//
//  Created by Ashley Ng on 9/4/17.
//  Copyright © 2017 Ashley Ng. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var numberOfTasks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(listName: String, numberOfTasks: Int) {
        self.listName.text = listName
        self.numberOfTasks.text = "\(numberOfTasks) Tasks"
    }

}
