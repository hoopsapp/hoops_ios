//
//  SettingsViewController.swift
//  Hoops
//
//  Created by Joe on 03.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: TableViewController, MFMessageComposeViewControllerDelegate {
    //var viewController : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row){
        case 0:
        // aboutHoopSegue
            //self.performSegueWithIdentifier("aboutHoopsSegue", sender: self)
            break // About Hoops
        case 1:
            tellAFriend()
            break //Tell a friend
        default: break
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        dismissViewControllerAnimated(true, completion: nil)
        
        // TODO
        /*
        if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled")
        else if (result == MessageComposeResultSent)
        NSLog(@"Message sent")
        else
        NSLog(@"Message failed")
        }
        */
        
    }

    
    func tellAFriend(){
        var text = "SMS Text"
        if (!MFMessageComposeViewController.canSendText()){
            displaySimpleAlert(title: "Error", message: "Your Device does not support SMS!")
            return
        }
        
        var recipients = [String]()
        var message = "Hey there, check out hoops"
        
        var controller = MFMessageComposeViewController()
        controller.messageComposeDelegate = self
        controller.recipients = recipients
        controller.body = message
        
        presentViewController(controller, animated: true, completion: nil)
    }
    

}
