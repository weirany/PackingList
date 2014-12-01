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
    
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tripNameTextFieldEditingChanged(sender: UITextField) {
        self.navigationItem.rightBarButtonItem!.enabled = (self.tripName.text != "")
    }

    @IBAction func doneClicked(sender: UIBarButtonItem) {
        // save data
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let tripEntity =  NSEntityDescription.entityForName("Trip", inManagedObjectContext:managedContext)
        let trip = NSManagedObject(entity: tripEntity!, insertIntoManagedObjectContext:managedContext) as Trip
        
        // trip attributes
        trip.tripId = NSUUID().UUIDString
        trip.name = self.tripName.text
        trip.startDate = self.tripStartDate.date
        
        // get ready all items
        let itemEntity =  NSEntityDescription.entityForName("Item", inManagedObjectContext:managedContext)
        let item = NSManagedObject(entity: itemEntity!, insertIntoManagedObjectContext:managedContext) as Item
        var itemArray = [Item]()
        for i in 0..<self.items.count {
            item.itemId = NSUUID().UUIDString
            item.name = self.items[i]
            item.isDone = 0
            itemArray.append(item)
        }
        trip.items = NSSet(array: itemArray)
        
        // saving
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
