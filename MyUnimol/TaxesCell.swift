//
//  TaxesCell.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 17/03/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class TaxesCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var billId: UILabel!
    @IBOutlet weak var deadlineDate: UILabel!
    @IBOutlet weak var accademicYear: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
