//
//  Item.swift
//  PackingList
//
//  Created by Ye, Weiran on 11/30/14.
//  Copyright (c) 2014 Ye, Weiran. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
class Item: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var itemId: String
    @NSManaged var isDone: NSNumber
    @NSManaged var whatTrip: Trip

}
