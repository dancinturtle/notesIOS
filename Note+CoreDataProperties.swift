//
//  Note+CoreDataProperties.swift
//  notes
//
//  Created by Amy Giver on 6/5/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Note {

    @NSManaged var details: String?
    @NSManaged var date: String?
    @NSManaged var time: String?

}
