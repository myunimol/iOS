//
//  Contact.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 08/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss

///Contains the info for a contact
public struct Contact: Decodable {
    
    let fullname: String?
    let role: String?
    let building: String?
    let internalTelephone: String?
    let externalTelephone: String?
    let email: String?
    
    public init?(json: JSON) {
        self.fullname = "fullname" <~~ json
        self.role = "role" <~~ json
        self.building = "building" <~~ json
        self.internalTelephone = "internalTelephone" <~~ json
        self.externalTelephone = "externalTelephone" <~~ json
        self.email = "email" <~~ json
    }
}

///Contains an arrays of `Contact` elements
public struct ContactList {
    
    ///An array of `Contacts`
    var contacts = [Contact]()
    
    init(json: JSON) {
        self.contacts = [Contact].fromJSONArray(("contacts" <~~ json)!)
    }
}

///The singleton which contains contacs infos
public class ContactBean {
    
    public static let sharedIntance = ContactBean()
    
    ///The `ContactList` object which stores an array of `Contact` objects
    public var contacts: ContactList?
    
    private init() { }
}