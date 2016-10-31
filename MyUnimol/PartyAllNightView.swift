//
//  PartyAllNightView.swift
//  MyUnimol
//
//  Created by Matteo Merola on 10/31/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation
import UIKit

class PartyAllNightView : UIView {
    var titles = [
        "Sabato sera!",
        "Sabato",
        "Mi hanno bocciato",
        "Sabatodì",
        "Sabato fascista"
    ]
    var bottom_lines = [
        "Divertiti, domani è Domenica... Eccheccà",
        "Fanc**o agli esami, stasera pizzata con gli amici",
        "Ma oggi è Sabato e entro stanotte avrò sbocciato...",
        "Stasera mi autodistruggerò così...",
        "Il giorno si ozia e la sera si va in pista"
    ]
    var images = [
        "ballo",
        "pizzata",
        "sboccio",
        "whiskey",
        "donne"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView() {
        let random_index = Int(arc4random_uniform(UInt32(self.titles.count)))
        let title_label : UILabel = UILabel()
        title_label.frame = CGRectMake(50, 50, self.frame.width-100, 100)
        title_label.backgroundColor=UIColor.whiteColor()
        title_label.textAlignment = .Center
        title_label.textColor = UIColor.blackColor()
        title_label.text = self.titles[random_index]
        title_label.font = UIFont.boldSystemFontOfSize(30)
        title_label.hidden=false
        self.addSubview(title_label)
        
        let bottom_line_label : UILabel = UILabel()
        bottom_line_label.frame = CGRectMake(25, (self.frame.width-200+150), self.frame.width-50, 100)
        bottom_line_label.backgroundColor=UIColor.whiteColor()
        bottom_line_label.textAlignment = .Center
        bottom_line_label.textColor = UIColor.blackColor()
        bottom_line_label.text = self.bottom_lines[random_index]
        bottom_line_label.numberOfLines = 2
        bottom_line_label.hidden=false
        self.addSubview(bottom_line_label)
        
        let img_name = self.images[random_index]+".png"
        let image : UIImageView = UIImageView()
        image.image = UIImage(named: img_name)
        image.frame = CGRect(x: 100, y: 150, width: self.frame.width-200, height: self.frame.width-200)
        self.addSubview(image)
    }
}