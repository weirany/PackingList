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
    
    // app info
    let _appId = "954200327"
    let _appName = "Packing List"
    let _appContactEmail = "talkanpackinglist@gmail.com"
    let _defaultRateAppCountDownTrigger = -300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prompt to rate the app? 
        // Logic: 
        // - count down starts at zero
        // - count every ViewDidLoad (minus 1 every time)
        // - only triggered if count-down becomes < (default trigger)
        // Options are:
        // - Leave 5-star rating -> 1) set count-down to Int.max; 2) go to review 
        // - Not 5-star yet, suggestion -> 1) set count-down to 10x; 2) go to email 
        // - Remind me later -> reset count-down to zero
        // - Don't show again -> set count-down to Int.max
        let currentRateAppCountDown = NSUserDefaults.standardUserDefaults().integerForKey("RateAppCountDown")
        
        if currentRateAppCountDown < _defaultRateAppCountDownTrigger {
            let optionMenu = UIAlertController(title: "Rate me", message: "If you enjoy using this app, would you mind taking a moment to rate it? That helps more people find out and use this app. Thanks for your support! ", preferredStyle: .ActionSheet)
            
            let rateTheApp = { (action:UIAlertAction!) -> Void in
                NSUserDefaults.standardUserDefaults().setInteger(Int.max, forKey: "RateAppCountDown")
                let templateReviewURLiOS8 = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=" + self._appId +  "&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
                UIApplication.sharedApplication().openURL(NSURL(string: templateReviewURLiOS8)!)
            }
            
            let emailSuggestion = { (action:UIAlertAction!) -> Void in
                let newCountDown = (0 - self._defaultRateAppCountDownTrigger)*10
                NSUserDefaults.standardUserDefaults().setInteger(newCountDown, forKey: "RateAppCountDown")
                let mailToUrl = "mailto:" + self._appContactEmail + "?Subject="
                    + self._appName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "%20suggestion"
                UIApplication.sharedApplication().openURL(NSURL(string: mailToUrl)!)
            }

            let remindLater = { (action:UIAlertAction!) -> Void in
                NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "RateAppCountDown")
            }

            let dontShow = { (action:UIAlertAction!) -> Void in
                NSUserDefaults.standardUserDefaults().setInteger(Int.max, forKey: "RateAppCountDown")
            }

            optionMenu.addAction(UIAlertAction(title: "Rate me 5-start", style: .Default, handler: rateTheApp))
            optionMenu.addAction(UIAlertAction(title: "Not 5-start yet, email my suggestion", style: .Default, handler: emailSuggestion))
            optionMenu.addAction(UIAlertAction(title: "Remind me later", style: .Default, handler: remindLater))
            optionMenu.addAction(UIAlertAction(title: "Don't show again", style: .Default, handler: dontShow))
            
            self.presentViewController(optionMenu, animated: true, completion: nil)
        }
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
        if tripAllPacked(self._trips[indexPath.row]) {
            cell.detailTextLabel!.text! += " (👏 All Packed!)"
        }
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

    func tripAllPacked (trip: Trip)-> Bool {
        var result = true
        for item in trip.items {
            if let i = item as? Item {
                if i.isDone == 0 {
                    result = false
                    break
                }
            }
        }
        return result
    }

}
