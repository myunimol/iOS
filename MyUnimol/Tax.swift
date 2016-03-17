//
//  Tax.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 17/03/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss

public struct Tax: Decodable {
    
    let billId: String?
    let bullettinCode: String?
    let year: String?
    let description: String?
    let expiringDate: String?
    let amount: Double?
    let statusPayment: String?
    
    public init?(json: JSON) {
        self.billId = "billId" <~~ json
        self.bullettinCode = "bullettinCode" <~~ json
        self.year = "year" <~~ json
        self.description = "description" <~~ json
        self.expiringDate = "expiringDate" <~~ json
        self.amount = "amount" <~~ json
        self.statusPayment = "statusPayment" <~~ json
    }
}

public struct Taxes {
    
    let taxes = [Tax]()
    
    init(json: JSON) {
        self.taxes = [Tax].fromJSONArray(("taxes" <~~ json)!)
    }
}

public class TaxClass {
    
    public static let sharedInstance = TaxClass()
    
    public var taxes: Taxes?
    
    private init() { }
}

