//
//  DetailsViewController.swift
//  notes
//
//  Created by Amy Giver on 6/5/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
import CoreData



class DetailsViewController: UIViewController, UITextViewDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    var addNewNote = false
    var editOldNote = false
    var editNewNote = false
    var noteToEdit: Note?

    var notes = [Note]()


    
    @IBOutlet weak var textView: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
        textView.delegate = self
        if let noteBeingEdited = noteToEdit {
            textView.text = noteBeingEdited.details
        }
        
    }
  
    func textViewDidChange(textView: UITextView) {
        
        if addNewNote == true {
            let entity = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext:managedObjectContext) as! Note
            entity.details = textView.text
            let currdate = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let convertedDate = dateFormatter.stringFromDate(currdate)
            dateFormatter.dateFormat = "MM-dd-yyy HH:mm:ss"
            let time = dateFormatter.stringFromDate(currdate)
            
            entity.date = convertedDate
            entity.time = time
            
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                    print("Success")
                } catch {
                    print("\(error)")
                }
            }
            addNewNote = false
            editNewNote = true
            fetchAll()
        }
        
        if editNewNote == true {
            var editingNewThing = notes[notes.count-1]
            editingNewThing.details = textView.text
            let currdate = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let convertedDate = dateFormatter.stringFromDate(currdate)
            dateFormatter.dateFormat = "MM-dd-yyy HH:mm:ss"
            let time = dateFormatter.stringFromDate(currdate)
            
            editingNewThing.date = convertedDate
            editingNewThing.time = time
            
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                    print("Success with editing")
                } catch {
                    print("\(error)")
                }
            }
            

            
           print("editing the new thing", notes[notes.count-1])

        
        }
        
        if editOldNote == true {
            if let noteBeingEdited = noteToEdit {
                noteBeingEdited.details = textView.text
                
                let currdate = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let convertedDate = dateFormatter.stringFromDate(currdate)
                dateFormatter.dateFormat = "MM-dd-yyy HH:mm:ss"
                let time = dateFormatter.stringFromDate(currdate)

                
                noteBeingEdited.date = convertedDate
                noteBeingEdited.time = time
                
                if managedObjectContext.hasChanges {
                    do {
                        try managedObjectContext.save()
                        print("Success with editing")
                    } catch {
                        print("\(error)")
                    }
                }

                



            }
            
        }
    }

    
    func fetchAll() {
        let userRequest = NSFetchRequest(entityName: "Note")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            notes = results as! [Note]
        } catch {
            print("\(error)")
        }
    }
    
    
    
    
    
    
    
}
