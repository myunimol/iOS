//
//  RecordBookCell.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 28/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class RecordBookCell: UITableViewCell {

    
    @IBOutlet weak var examName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var cfu: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
