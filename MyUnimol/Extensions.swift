//
//  Extensions.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 16/05/17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, metrics: [String: CGFloat]?, views: UIView...) {
        var viewsDictionary: [String: UIView] = [:]
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: metrics, views: viewsDictionary))
    }
}
