//
//  MyTripsTableViewController.swift
//  PackingList
//
//  Created by Ye, Weiran on 12/5/14.
//  Copyright (c) 2014 Ye, Weiran. All rights reserved.
//

import UIKit
import CoreData

class MyTripsTableViewController: BaseTableViewController {
    
    var _trips = [Trip]()
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
        return _trips.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tripCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = self._trips[indexPath.row].name
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        cell.detailTextLabel!.text = dateFormatter.stringFromDate(self._trips[indexPath.row].startDate)
        return cell
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        _managedContext = appDelegate.managedObjectContext!
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        let fetchRequest = NSFetchRequest(entityName:"Trip")
        fetchRequest.sortDescriptors = [sortDescriptor]
        var error: NSError?
        let fetchedResults = _managedContext.executeFetchRequest(fetchRequest, error: &error) as [Trip]?
        if let results = fetchedResults {
            self._trips = results
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "checkListSegue" {
            let path = self.tableView.indexPathForSelectedRow()
            let nextController = segue.destinationViewController as ItemCheckListTableViewController
            nextController._tripId = _trips[path!.row].tripId
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            _managedContext.deleteObject(_trips[indexPath.row])
            _trips.removeAtIndex(indexPath.row)
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
    
    @IBAction func addButtonClicked(sender: UIBarButtonItem) {
        // don't show choices when there is no existing trip
        if _trips.count == 0 {
            self.performSegueWithIdentifier("fromScratchSegue", sender: self)
        }
        else {
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let callFromScratch = { (action:UIAlertAction!) -> Void in
                self.performSegueWithIdentifier("fromScratchSegue", sender: self)
            }
            
            let callClone = { (action:UIAlertAction!) -> Void in
                self.performSegueWithIdentifier("cloneSegue", sender: self)
            }
            
            optionMenu.addAction(UIAlertAction(title: "Create new from scratch", style: .Default, handler: callFromScratch))
            optionMenu.addAction(UIAlertAction(title: "By cloning an existing trip", style: .Default, handler: callClone))
            optionMenu.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            self.presentViewController(optionMenu, animated: true, completion: nil)
        }
    }


}
