//
//  CalendarCell.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 31/07/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {
    
    @IBOutlet weak var lesson: UILabel!
    @IBOutlet weak var start_hour: UILabel!
    @IBOutlet weak var end_hour: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var dot: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
