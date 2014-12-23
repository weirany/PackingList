//
//  TripTypeTableViewController.swift
//  PackingList
//
//  Created by Ye, Weiran on 10/31/14.
//  Copyright (c) 2014 Ye, Weiran. All rights reserved.
//

import UIKit

class TripTypeTableViewController: BaseTableViewController {
    
    var _typeSelected:[Bool] = [true, false, false, false]
    let _prefilledItemsGeneral = ["clothes","money","passport/id","personal hygiene","medicines","first aid","books","chargers","sunglasses"]
    let _prefilledItemsBusiness = ["business cards","laptop"]
    let _prefilledItemsFamily = ["snacks","toys","baby monitor","pacifiers","stroller","diapers"]
    let _prefilledItemsRomantic = ["wine opener","bathing suit","birth control"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
}
