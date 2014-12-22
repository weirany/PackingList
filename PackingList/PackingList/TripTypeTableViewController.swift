//
//  TripTypeTableViewController.swift
//  PackingList
//
//  Created by Ye, Weiran on 10/31/14.
//  Copyright (c) 2014 Ye, Weiran. All rights reserved.
//

import UIKit

class TripTypeTableViewController: UITableViewController {
    
    var _typeSelected:[Bool] = [true, false, false, false]
    let _prefilledItemsGeneral = ["clothes","money","passport/id","personal hygiene","medicines","first aid","books","chargers","sunglasses"]
    let _prefilledItemsBusiness = ["business cards","laptop"]
    let _prefilledItemsFamily = ["snacks","toys","baby monitor","pacifiers","stroller","diapers"]
    let _prefilledItemsRomantic = ["wine opener","bathing suit","birth control"]

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
    
    @IBAction func tripTypeChanged(sender: UISwitch) {
        _typeSelected[sender.tag] = sender.on
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var packingListViewController = segue.destinationViewController as PackingListTableViewController
        // populate items based on selected trip types
        if _typeSelected[0] { // general
            packingListViewController._items += _prefilledItemsGeneral
        }
        if _typeSelected[1] { // business
            packingListViewController._items += _prefilledItemsBusiness
        }
        if _typeSelected[2] { // family
            packingListViewController._items += _prefilledItemsFamily
        }
        if _typeSelected[3] { // romantic
            packingListViewController._items += _prefilledItemsRomantic
        }
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
