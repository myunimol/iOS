//
//  CoreDataController.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 02/08/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataController {
    
    /// the `CoreData` singleton object
    static let sharedIstanceCData = CoreDataController()
    
    private var context: NSManagedObjectContext
    
    // Le quattro propietà serviranno per memorizzare i valori contenuti nei rispettivi text field della classe CalendarDataViewController
    var matsDataField :String
    var commentDataField :String
    var startHourNSDate: NSDate
    var endHourNSDate: NSDate
    
    
    private init() {
        let application = UIApplication.sharedApplication().delegate as! AppDelegate
        self.context = application.managedObjectContext
        self.matsDataField = String()
        self.commentDataField = String()
        self.startHourNSDate = NSDate()
        self.endHourNSDate = NSDate()
    }
    
    
    /// Closure per il fetch ed ordinamento campi del Core Data
    lazy var fetchedResultController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Orario")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "materia", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    /// Funzione per il salvataggio dei dati sul Core Data
    func addOrario(materia: String, commento: String, data_inizio: NSDate, data_termine: NSDate) {
        let entity = NSEntityDescription.entityForName("Orario", inManagedObjectContext: self.context)
        let newOrario = Orario(entity: entity!, insertIntoManagedObjectContext: self.context)
        newOrario.materia = materia
        newOrario.commento = commento
        newOrario.data_inizio = data_inizio
        newOrario.data_termine = data_termine
        do {
            try self.context.save()
        } catch let errore {
            print("[CDC] Problema salvataggio Materia: \(newOrario.materia!) in memoria")
            print("  Stampo l'errore: \n \(errore) \n")
        }
        
        print("[CDC] Orario \(newOrario.materia!) salvato in memoria correttamente")
    }
}
