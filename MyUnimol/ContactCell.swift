//
//  ContactCell.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 10/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var telephone: UITextView!
    @IBOutlet weak var email: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
