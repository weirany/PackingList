//
//  PackingListTableViewController.swift
//  PackingList
//
//  Created by Ye, Weiran on 11/3/14.
//  Copyright (c) 2014 Ye, Weiran. All rights reserved.
//

import UIKit

class PackingListTableViewController: BaseTableViewController {

    var _items = [String]()
    var _newItemText = UITextField() as UITextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // zero item?
        if self._items.count == 0 {
            self.navigationItem.rightBarButtonItem!.enabled = false
        }
        else {
            self.navigationItem.rightBarButtonItem!.enabled = true
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
        return _items.count + 1
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
            
            let cell = tableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) as CheckListTableViewCell
            
            // item name
            cell.textLabel.text = self._items[indexPath.row-1]
            
            // delete button
            cell.deleteButton.setTitle("❌", forState: UIControlState.Normal)
            cell.deleteButton.addTarget(self, action: "deleteButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)

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
            self.navigationItem.rightBarButtonItem!.enabled = true
        }
    }
    
    func deleteButtonClicked(sender:UIButton!) {
        let indexPath = self.tableView.indexPathForView(sender) as NSIndexPath!
        self._items.removeAtIndex(indexPath.row-1)
        self.tableView.reloadData()
        // zero item?
        if self._items.count == 0 {
            self.navigationItem.rightBarButtonItem!.enabled = false
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tripNameViewController = segue.destinationViewController as TripNameViewController
        tripNameViewController._items = self._items
    }


}
