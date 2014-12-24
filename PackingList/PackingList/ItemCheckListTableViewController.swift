//
//  ItemCheckListTableViewController.swift
//  PackingList
//
//  Created by Ye, Weiran on 12/6/14.
//  Copyright (c) 2014 Ye, Weiran. All rights reserved.
//

import UIKit
import CoreData

class ItemCheckListTableViewController: BaseTableViewController {

    var _tripId = ""
    var _trip: Trip?
    var _managedContext = NSManagedObjectContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getAllItems().count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("checkListItem", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = getAllItems()[indexPath.row].name
        if getAllItems()[indexPath.row].isDone != 0 {
            cell.textLabel.textColor = .lightGrayColor()
            cell.accessoryType = .Checkmark
        }
        else {
            cell.textLabel.textColor = .blackColor()
            cell.accessoryType = .None
        }
        
        return cell
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // load items from core data
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        _managedContext = appDelegate.managedObjectContext!
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        let fetchRequest = NSFetchRequest(entityName:"Trip")
        fetchRequest.predicate = NSPredicate(format: "tripId == %@", _tripId)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var error: NSError?
        let fetchedResults = _managedContext.executeFetchRequest(fetchRequest, error: &error) as [Trip]?
        if let results = fetchedResults {
            _trip = results[0]
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        getAllItems()[indexPath.row].isDone = (getAllItems()[indexPath.row].isDone == 0 ? 1 : 0)
        
        var error: NSError?
        if !_managedContext.save(&error) {
            // todo: logging
            // no good fallback handling can be done, just let the UI and core data out of sync. :(
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            _managedContext.deleteObject(getAllItems()[indexPath.row])
            // saving
            var error: NSError?
            if !_managedContext.save(&error) {
                // todo: logging. no good fallback handling can be done 
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    @IBAction func AddItem(sender: UIBarButtonItem) {
        var prompt = UIAlertController(title: "New item", message: "", preferredStyle: .Alert)
        prompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "something more to pack"
            textField.autocorrectionType =  .Default
        })
        prompt.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{(alertAction:UIAlertAction!) in
            let text = (prompt.textFields![0] as UITextField).text
            if text != "" {
                self.addOneItem(text)
                self.tableView.reloadData()
            }
        }))
        self.presentViewController(prompt, animated: true, completion: nil)
    }
    
    func getAllItems()-> [Item] {
        var items = [Item]()
        if let t = _trip {
            items = t.items.allObjects as [Item]
            items.sort({ $0.name.lowercaseString < $1.name.lowercaseString })
        }
        return items
    }
    
    func addOneItem(newItemName: String) {
        let itemEntity =  NSEntityDescription.entityForName("Item", inManagedObjectContext:_managedContext)
        let item = NSManagedObject(entity: itemEntity!, insertIntoManagedObjectContext:_managedContext) as Item
        item.itemId = NSUUID().UUIDString
        item.name = newItemName
        item.isDone = 0
        var items = _trip!.items.allObjects as [Item]
        items.append(item)
        _trip!.items = NSSet(array: items)
        var error: NSError?
        if !_managedContext.save(&error) {
            // todo: logging. no good fallback handling can be done
        }
    }
}
