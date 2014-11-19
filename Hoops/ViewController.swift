//
//  ViewController.swift
//  Hoops
//
//  Created by Daniel on 17.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, PDeliversStatusAlerts{
    let notifCenter = NSNotificationCenter.defaultCenter()
    
    override init() {
        super.init()
        notifCenter.addObserver(self, selector: "displayConnectionLostAlert", name: kConnectionLostNotification, object: self)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        notifCenter.addObserver(self, selector: "displayConnectionLostAlert", name: kConnectionLostNotification, object: self)
    }
    
    
    func displaySimpleAlert(#title:String, message:String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
       
    }

    func displayModalDialog(#title: String, message: String, yesHandler: ((UIAlertAction!) -> Void)?, noHandler: ((UIAlertAction!) -> Void)?) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: noHandler))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: yesHandler))

        self.presentViewController(alert, animated: true, completion: nil)
    }
}