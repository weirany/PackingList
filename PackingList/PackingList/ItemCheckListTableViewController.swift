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
    var _newItemText = UITextField() as UITextField
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
        return getAllItems().count + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // handle input (new item) row
        if indexPath.row == 0 {
            let cell = UITableViewCell()
            
            // text box
            self._newItemText = UITextField() as UITextField
            self._newItemText.setTranslatesAutoresizingMaskIntoConstraints(false)
            self._newItemText.placeholder = "add more items now, or later..."
            self._newItemText.borderStyle = UITextBorderStyle.RoundedRect
            cell.contentView.addSubview(self._newItemText)
            
            // add button
            let addButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            addButton.setTranslatesAutoresizingMaskIntoConstraints(false)
            addButton.setTitle("➕", forState: UIControlState.Normal)
            addButton.addTarget(self, action: "addButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.contentView.addSubview(addButton)
            
            // view dictionary (for one row)
            let viewDict = ["newItemText":_newItemText, "addButton":addButton]
            
            // position
            let cell_c_h = NSLayoutConstraint.constraintsWithVisualFormat("|-(15)-[newItemText][addButton]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
            let cell_c_v = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[newItemText]-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewDict)
            cell.addConstraints(cell_c_h)
            cell.addConstraints(cell_c_v)
            
            return cell
        }
        else { // all other item rows
            
            let cell = tableView.dequeueReusableCellWithIdentifier("checkListItem", forIndexPath: indexPath) as CheckListTableViewCell
            
            // isDone?
            let isDone = getAllItems()[indexPath.row-1].isDone != 0
            
            // item name
            let normalAttributes = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue]
            let strikeThroughAttributes = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
            var labelString:NSAttributedString
            if isDone {
                labelString = NSAttributedString(string: "☑︎  " + getAllItems()[indexPath.row-1].name, attributes: strikeThroughAttributes)
                cell.textLabel.textColor = .lightGrayColor()
            }
            else {
                labelString = NSAttributedString(string: "☐  " + getAllItems()[indexPath.row-1].name, attributes: normalAttributes)
                cell.textLabel.textColor = .blackColor()
            }
            cell.textLabel.attributedText = labelString
            
            // delete button
            cell.deleteButton.addTarget(self, action: "deleteButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            if isDone {
                cell.deleteButton.enabled = false
                cell.deleteButton.setTitle("", forState: UIControlState.Normal)
            }
            else {
                cell.deleteButton.enabled = true
                cell.deleteButton.setTitle("❌", forState: UIControlState.Normal)
            }
            
            return cell
        }
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
        getAllItems()[indexPath.row-1].isDone = (getAllItems()[indexPath.row-1].isDone == 0 ? 1 : 0)
        
        var error: NSError?
        if !_managedContext.save(&error) {
            // todo: logging
            // no good fallback handling can be done, just let the UI and core data out of sync. :(
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func addButtonClicked(sender:UIButton!) {
        if self._newItemText.text == "" {
            return
        }
        else {
            addOneItem(self._newItemText.text)
            self._newItemText.text = ""
            self.tableView.reloadData()
        }
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
    
    func deleteButtonClicked(sender:UIButton!) {
        let indexPath = self.tableView.indexPathForView(sender) as NSIndexPath!
        
        _managedContext.deleteObject(getAllItems()[indexPath.row-1])
        // saving
        var error: NSError?
        if !_managedContext.save(&error) {
            // todo: logging. no good fallback handling can be done
        }
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func getAllItems()-> [Item] {
        var items = [Item]()
        if let t = _trip {
            items = t.items.allObjects as [Item]
            items.sort({ $0.name.lowercaseString < $1.name.lowercaseString })
        }
        return items
    }

}
