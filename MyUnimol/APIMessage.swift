//
//  APIMessage.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 24/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss

/// Stores a generic response message from API server
public struct APIMessage: Decodable {
    let msg: String?
    let result: String?
    
    public init?(json: JSON) {
        self.msg = "msg" <~~ json
        self.result = "result" <~~ json
    }
}
