//
//  Orario+CoreDataProperties.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 02/08/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Orario {

    @NSManaged var materia: String?
    @NSManaged var commento: String?
    @NSManaged var data_inizio: NSDate?
    @NSManaged var data_termine: NSDate?
    @NSManaged var day: String?

}
