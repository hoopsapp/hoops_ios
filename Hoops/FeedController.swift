//
//  FeedTableViewController.swift
//  Hooptest
//
//  Created by Joe on 19.08.14.
//  Copyright (c) 2014 Hoop Inc. All rights reserved.
//

import UIKit

class FeedController: TableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adjusting text size without quitting app
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onContentSizeChange:",
            name: UIContentSizeCategoryDidChangeNotification,
            object: nil)
        
        // set table row height
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // removes the back button after clicked on send button to write a post
        self.navigationItem.hidesBackButton = true
        
        // refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: Selector("refresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl!.backgroundColor = UIColor.grayColor()
        self.refreshControl!.tintColor = UIColor.whiteColor()
        self.tableView.addSubview(refreshControl!)
    }
   
    func reloadFeed(note: NSNotification){
        tableView.reloadData()
    }
    
    func refresh(sender: AnyObject){
        self.refreshControl!.endRefreshing()
    }
    
    // called when the text size was changed by the user 
    func onContentSizeChange(notification: NSNotification) {
        tableView.reloadData()
    }
}

