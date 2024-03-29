//
//  BaseViewController.swift
//  PackingList
//
//  Created by Ye, Weiran on 12/23/14.
//  Copyright (c) 2014 Ye, Weiran. All rights reserved.
//

import UIKit
import iAd

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.canDisplayBannerAds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let currentRateAppCountDown = NSUserDefaults.standardUserDefaults().integerForKey("RateAppCountDown")
        NSUserDefaults.standardUserDefaults().setInteger(currentRateAppCountDown-1, forKey: "RateAppCountDown")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
