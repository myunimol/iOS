//
//  TimeTableCell.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 17.05.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import UIKit

class TimeTableCell: UITableViewCell {
    
    
    @IBOutlet weak var startingTime: UILabel!

    @IBOutlet weak var endingTime: UILabel!
    
    @IBOutlet weak var lessonName: UILabel!
    
    @IBOutlet weak var lessonComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
