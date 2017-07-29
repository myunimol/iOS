//
//  DefaultNewsCell.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 07/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class DefaultNewsCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var body: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
