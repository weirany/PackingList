//
//  Trip.swift
//  PackingList
//
//  Created by Ye, Weiran on 11/30/14.
//  Copyright (c) 2014 Ye, Weiran. All rights reserved.
//

import Foundation
import CoreData

@objc(Trip)
class Trip: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var startDate: NSDate
    @NSManaged var tripId: String
    @NSManaged var items: NSSet

}
