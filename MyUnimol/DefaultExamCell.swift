//
//  DefaultExamCell.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 08/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class DefaultExamCell: UITableViewCell {

    @IBOutlet weak var examName: UILabel!
    
    @IBOutlet weak var professor: UILabel!
    
    @IBOutlet weak var examDate: UILabel!
    
    @IBOutlet weak var expiringDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
