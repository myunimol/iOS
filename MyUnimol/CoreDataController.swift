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
    var startHourNSDate: Date
    var endHourNSDate: Date
    var dayOfTheWeek: String
    var labelOraInizioToString :String?
    var labelOraTermineToString :String?
    
    
    fileprivate init() {
        let application = UIApplication.shared.delegate as! AppDelegate
        self.context = application.managedObjectContext
        self.matsDataField = String()
        self.commentDataField = String()
        self.startHourNSDate = Date()
        self.endHourNSDate = Date()
        self.dayOfTheWeek = "monday"
    }
    
    func loadAllOrario(_ perDay: String) -> [Orario] {
        print("Recupero tutti gli Orari dal context ")
        
        var array = [Orario]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Orario")
        
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
            array = try self.context.fetch(fetchRequest) as! [Orario]
            
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
        print(array)
    }
    
    /** 
        Function to save a new lesson to Core Data
        
        - Parameters:
            - materia:      the name of the lesson
            - comment:      an optional comment
            - data_inizio:  staring time of the lesson
            - data_termina: end time of the lesson
            - day:          the day of the lesson
    */
    func addOrario(_ materia: String, commento: String, data_inizio: Date, data_termine: Date, day: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Orario", in: self.context)
        let newOrario = Orario(entity: entity!, insertInto: self.context)
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
    }
    
    /**
        Update a given lesson stored in the Core Data
        
        - parameter oldLesson:      the old lesson to update
        - parameter newLesson:      the new lesson ti save
    */
    func updateLesson(oldLesson: Orario, newLesson: LessonTime) {
        var times = [Orario]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Orario")
        
        let predicate = NSPredicate(format: "materia == %@ AND day == %@ AND commento == %@ AND data_inizio == %@ AND data_termine == %@ ",
                                    oldLesson.materia!, oldLesson.day!, oldLesson.commento!, oldLesson.data_inizio! as NSDate, oldLesson.data_termine! as NSDate)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            times = try self.context.fetch(fetchRequest) as! [Orario]
            let lessonToChange = times[0]
            
            lessonToChange.setValue(newLesson.lessonName, forKey: "materia")
            lessonToChange.setValue(newLesson.commentName, forKey: "commento")
            lessonToChange.setValue(newLesson.startHour, forKey: "data_inizio")
            lessonToChange.setValue(newLesson.endHour, forKey: "data_termine")
            lessonToChange.setValue(newLesson.dayOfTheWeek, forKey: "day")
            
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        } catch let error {
            print("Error with request: \(error)")        }

    }
}
