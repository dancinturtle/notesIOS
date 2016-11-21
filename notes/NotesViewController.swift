//
//  ViewController.swift
//  notes
//
//  Created by Amy Giver on 6/5/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating{
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var notes = [Note]()
    
    var editThisEntry = false
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchController = UISearchController(searchResultsController:nil)
    
    var filteredData = [Note]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetchAll()
        filteredData = notes
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    
    @IBAction func composeButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("detailsSegue", sender: self)
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailsSegue" {
           
            let vc = segue.destinationViewController as! DetailsViewController
            
            
            if editThisEntry == false {
            vc.addNewNote = true
            }
            
            if editThisEntry == true {
                editThisEntry = false
                vc.addNewNote = false
                vc.editOldNote = true
                if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                    vc.noteToEdit = notes[indexPath.row]
                    vc.noteToEditIndexPath = indexPath.row
                }
            }
        }
    }
    
 
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredData = notes.filter { data in
            return data.details!.lowercaseString.containsString(searchText.lowercaseString)
            
        }
        tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath)
        let note: Note
        if searchController.active && searchController.searchBar.text != "" {
            note = filteredData[indexPath.row]
        } else {
            note = notes[indexPath.row]
        }
        if let noteDetails = filteredData[indexPath.row].details {
            if let noteDate = filteredData[indexPath.row].date {
                cell.textLabel?.text = noteDetails
                cell.detailTextLabel?.text = noteDate

            }
        }

        return cell
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != " " {
            return filteredData.count
        }
        
        return notes.count
    }
    
    func fetchAll() {
        let dateSort = NSSortDescriptor(key: "time", ascending: false)
        let userRequest = NSFetchRequest(entityName: "Note")
        userRequest.sortDescriptors = [dateSort]
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            notes = results as! [Note]
            filteredData = notes
        } catch {
            print("\(error)")
        }
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete {
            managedObjectContext.deleteObject(filteredData[indexPath.row])
        }
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success deleting")
            } catch {
                print("\(error)")
            }
        }
        filteredData.removeAtIndex(indexPath.row)
        notes.removeAtIndex(indexPath.row)
        
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        editThisEntry = true
        performSegueWithIdentifier("detailsSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
        print("Index Path!!", indexPath)
    }
    
    
    
    

    override func viewDidAppear(animated: Bool) {
        fetchAll()
        tableView.reloadData()
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NotesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController){
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}



