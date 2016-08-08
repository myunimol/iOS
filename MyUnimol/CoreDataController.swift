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
    
    var context: NSManagedObjectContext
    
    // Le seguenti propietà serviranno per memorizzare i valori contenuti nei rispettivi text field
    // della classe CalendarDataViewController
    var matsDataField :String
    var commentDataField :String
    var startHourNSDate: NSDate
    var endHourNSDate: NSDate
    var dayOfTheWeek: String
    var labelOraInizioToString :String?
    var labelOraTermineToString :String?
    
    
    private init() {
        let application = UIApplication.sharedApplication().delegate as! AppDelegate
        self.context = application.managedObjectContext
        self.matsDataField = String()
        self.commentDataField = String()
        self.startHourNSDate = NSDate()
        self.endHourNSDate = NSDate()
        self.dayOfTheWeek = "monday"
    }
    
    func loadAllOrario(perDay: String) -> [Orario] {
        print("Recupero tutti gli Orari dal context ")
        
        var array = [Orario]()
        let fetchRequest = NSFetchRequest(entityName: "Orario")
        
        // Add Sort Descriptors
        // L'ordinamento è impostato in base all'ora di inizio della singola materia
        // agire sulla variabile "key" per cambiare il tipo di ordinamento
        let sortDescriptor = NSSortDescriptor(key: "data_inizio", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Creo un nuovo predicate che filtrerà il giorno selezionato nel segmented controller
        let predicate = NSPredicate(format: "day == %@", perDay)
        
        // Setto il predicate per la  fetch request
        fetchRequest.predicate = predicate
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            array = try self.context.executeFetchRequest(fetchRequest) as! [Orario]
            
            guard array.count > 0 else {print("Non ci sono elementi da leggere "); return []}
            
            // Scommentare il ciclo for per testare in locale NSManagedObject ritornato dalla executeFetchRequest
            /*
            for x in array {
                let book = x
                print("Materia \(book.materia!) - Commento \(book.commento!)")
            }
             */
            
        } catch let errore {
            print("[Problema esecuzione FetchRequest")
            print("Stampo l'errore: \n \(errore) \n")
        }
        return array
    }
    
    /// Funzione per il salvataggio dei dati sul Core Data
    func addOrario(materia: String, commento: String, data_inizio: NSDate, data_termine: NSDate, day: String) {
        let entity = NSEntityDescription.entityForName("Orario", inManagedObjectContext: self.context)
        let newOrario = Orario(entity: entity!, insertIntoManagedObjectContext: self.context)
        newOrario.materia = materia
        newOrario.commento = commento
        newOrario.data_inizio = data_inizio
        newOrario.data_termine = data_termine
        newOrario.day = day
        do {
            try self.context.save()
        } catch let errore {
            print("Problema salvataggio Materia: \(newOrario.materia!) in memoria")
            print("Stampo l'errore: \n \(errore) \n")
        }
        //print("Orario \(newOrario.materia!) salvato in memoria correttamente")
    }
}
