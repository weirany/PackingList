//
//  TripNameViewController.swift
//  PackingList
//
//  Created by Ye, Weiran on 10/28/14.
//  Copyright (c) 2014 Ye, Weiran. All rights reserved.
//

import UIKit

class TripNameViewController: UIViewController {

    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripStartDate: UIDatePicker!
    
    var items = [""]
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
