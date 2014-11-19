//
//  HoopsTableViewController.swift
//  Hoops
//
//  Created by Joe on 26.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKit

class HoopsTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    
    var feed:PostFeed?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        println("HoopsTableViewController: viewDidLoad() aufgerufen")
        //set table row height
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //load feed cell
        var nipName=UINib(nibName: "HoopsTableCell", bundle:nil)
        self.tableView.registerNib(nipName, forCellReuseIdentifier: "hoopsCell")
        
        // removes the back button after clicked on send button to write a post
        self.navigationItem.hidesBackButton = true
        // fatal error tabbar
        //self.navigationController.navigationItem.hidesBackButton = true
        
        //subscribe to feed changes
        // !!!!! NEED TO BE CHANGED !!!!!!
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadFeed:", name: "feed_changed", object: nil)
        
        //init feed
        // !!!!! NEED TO BE CHANGED !!!!!!
        //feed = Feed(client: HoopsClient.instance())
        
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func reloadFeed(note: NSNotification){
        tableView.reloadData()
    }
    
    /* called when add button is clicked
    func insertNewObject(sender: AnyObject) {
    if objects == nil {
    objects = NSMutableArray()
    }
    objects.insertObject(NSDate.date(), atIndex: 0)
    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }*/
    
    // #pragma mark - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if segue.identifier == "showDetail" {
        //let indexPath = self.tableView.indexPathForSelectedRow()
        //let object = objects[indexPath.row] as NSDate
        //(segue.destinationViewController as DetailViewController).detailItem = object
        //}
    }
    
    // #pragma mark - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed!.toArray().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("hoopsCell", forIndexPath: indexPath) as FeedTableCell
        let post = feed!.toArray()[indexPath.row]
        //cell.loadItem(user: post.owner, hoop: post.hashtag, post: post.text)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        /*if editingStyle == .Delete {
        objects.removeObjectAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }*/
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    
}

