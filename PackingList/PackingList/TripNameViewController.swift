//
//  TripNameViewController.swift
//  PackingList
//
//  Created by Ye, Weiran on 10/28/14.
//  Copyright (c) 2014 Ye, Weiran. All rights reserved.
//

import UIKit
import CoreData

class TripNameViewController: UIViewController {

    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripStartDate: UIDatePicker!
    
    var _items = [String]()
    var _managedContext = NSManagedObjectContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tripNameTextFieldEditingChanged(sender: UITextField) {
        self.navigationItem.rightBarButtonItem!.enabled = (self.tripName.text != "")
    }

    @IBAction func doneClicked(sender: UIBarButtonItem) {
        // save data
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        _managedContext = appDelegate.managedObjectContext!
        let tripEntity =  NSEntityDescription.entityForName("Trip", inManagedObjectContext:_managedContext)
        let trip = NSManagedObject(entity: tripEntity!, insertIntoManagedObjectContext:_managedContext) as Trip
        
        // trip attributes
        trip.tripId = NSUUID().UUIDString
        trip.name = self.tripName.text
        trip.startDate = self.tripStartDate.date
        
        // get ready all items
        let itemEntity =  NSEntityDescription.entityForName("Item", inManagedObjectContext:_managedContext)
        var itemArray = [Item]()
        for i in 0..<self._items.count {
            let item = NSManagedObject(entity: itemEntity!, insertIntoManagedObjectContext:_managedContext) as Item
            item.itemId = NSUUID().UUIDString
            item.name = self._items[i]
            item.isDone = 0
            itemArray.append(item)
        }
        trip.items = NSSet(array: itemArray)
        
        // saving
        var error: NSError?
        if !_managedContext.save(&error) {
            // todo: logging
            // no good fallback handling can be done, just jump back to home
        }
        self.navigationController!.popToRootViewControllerAnimated(true)

    }
}
