//
//  PackingListTableViewController.swift
//  PackingList
//
//  Created by Ye, Weiran on 11/3/14.
//  Copyright (c) 2014 Ye, Weiran. All rights reserved.
//

import UIKit

// refer to: http://stackoverflow.com/a/9274863/346676
extension UITableView {
    func indexPathForView (view : UIView) -> NSIndexPath? {
        let location = view.convertPoint(CGPointZero, toView:self)
        return indexPathForRowAtPoint(location)
    }
}

class PackingListTableViewController: UITableViewController {

    var _items = [String]()
    var _newItemText = UITextField() as UITextField
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return _items.count + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // handle input (new item) row
        if indexPath.row == 0 {
            let cell = UITableViewCell()
            
            // text box
            self._newItemText = UITextField() as UITextField
            self._newItemText.setTranslatesAutoresizingMaskIntoConstraints(false)
            self._newItemText.placeholder = "add a new item..."
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
            
            let cell = tableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) as UITableViewCell
            
            // item name
            cell.textLabel.text = self._items[indexPath.row-1]
            
            // delete button
            let deleteButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            deleteButton.setTranslatesAutoresizingMaskIntoConstraints(false)
            deleteButton.setTitle("❌", forState: UIControlState.Normal)
            deleteButton.addTarget(self, action: "deleteButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.contentView.addSubview(deleteButton)
            
            // view dictionary (for one row)
            let viewDict = ["deleteButton":deleteButton]
            
            // position
            let cell_c_h = NSLayoutConstraint.constraintsWithVisualFormat("[deleteButton]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
            let cell_c_v = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[deleteButton]-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewDict)
            cell.addConstraints(cell_c_h)
            cell.addConstraints(cell_c_v)
            
            return cell
        }
    }
    
    func addButtonClicked(sender:UIButton!) {
        if self._newItemText.text == "" {
            return
        }
        else {
            self._items.insert(self._newItemText.text!, atIndex: 0)
            self._newItemText.text = ""
            self.tableView.reloadData()
        }
    }
    
    func deleteButtonClicked(sender:UIButton!) {
        let indexPath = self.tableView.indexPathForView(sender) as NSIndexPath!
        self._items.removeAtIndex(indexPath.row-1)
        self.tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tripNameViewController = segue.destinationViewController as TripNameViewController
        tripNameViewController.items = self._items
    }


}
