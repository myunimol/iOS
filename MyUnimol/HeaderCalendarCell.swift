//
//  HeaderCalendarCell.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 31/07/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class HeaderCalendarCell: UITableViewCell {
 
@IBOutlet weak var segmentControlIndex: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
