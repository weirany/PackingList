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

    var typeSelected = [false, false, false, false]
    var items:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // populate items based on selected trip types
        if typeSelected[0] { // general
            items.append("passport")
            items.append("toothbrush")
        }
        if typeSelected[1] { // business
            items.append("business cards business cards business cards business cards ")
            items.append("laptop")
        }
        if typeSelected[2] { // family
            items.append("snacks")
            items.append("toys")
        }
        if typeSelected[3] { // romantic
            items.append("wine opener")
            items.append("bathing suit")
        }
        
        println("done loading view.")
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
        return items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) as UITableViewCell
        
        // item name
        let itemLabel = UILabel() as UILabel
        itemLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        itemLabel.text = items[indexPath.row]
        cell.contentView.addSubview(itemLabel)
        
        // delete button
        let deleteButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        deleteButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        deleteButton.setTitle("delete", forState: UIControlState.Normal)
        deleteButton.addTarget(self, action: "deleteButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.contentView.addSubview(deleteButton)
        
        // view dictionary (for one row)
        let viewDict = ["itemLabel":itemLabel, "deleteButton":deleteButton]
        
        // position
        let cell_c_h = NSLayoutConstraint.constraintsWithVisualFormat("|-[itemLabel]-[deleteButton]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        let cell_c_v = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[itemLabel]-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewDict)
        cell.addConstraints(cell_c_h)
        cell.addConstraints(cell_c_v)
        
        return cell
    }
    
    func deleteButtonClicked(sender:UIButton!) {
        let indexPath = self.tableView.indexPathForView(sender) as NSIndexPath!
        items.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
