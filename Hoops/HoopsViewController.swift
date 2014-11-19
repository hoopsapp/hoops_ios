//
//  HoopsViewController.swift
//  Hoops
//
//  Created by Joe on 26.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKit

class HoopsViewController: ViewController, UITableViewDelegate, UITableViewDataSource{
   
    @IBOutlet var followedButton: UIButton!
    @IBOutlet var nearbyButton: UIButton!
    @IBOutlet var hottestButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var hashtagFeed     : HashtagFeed?
    
    //var followedTags    : [Hashtag] = [Hashtag]()

    @IBAction func hottestButtonTapped(sender:AnyObject) {
        hashtagFeed = FeedFactory.instance().hottestHashtagFeed()
        notifCenter.removeObserver(self)
        notifCenter.addObserver(self, selector: "reloadFeed", name: hashtagFeed?.notificationName, object: nil)
        FeedFactory.instance().activateHashtagFeed(hashtagFeed!)
        reloadFeed()
    }
    
    @IBAction func nearbyButtonTapped(sender: AnyObject) {
        hashtagFeed = FeedFactory.instance().nearbyHashtagFeed()
        notifCenter.removeObserver(self)
        notifCenter.addObserver(self, selector: "reloadFeed", name: hashtagFeed?.notificationName, object: nil)
        notifCenter.addObserver(self, selector: "didReceiveLocationPermissionNeededNotification:", name: "location_permission_needed", object: nil)
        FeedFactory.instance().activateHashtagFeed(hashtagFeed!)
        reloadFeed()
    }
    
    @IBAction func followedButtonTapped(sender: AnyObject) {
        hashtagFeed = FeedFactory.instance().followedHashtagFeed()
        notifCenter.removeObserver(self)
        notifCenter.addObserver(self, selector: "reloadFeed", name: hashtagFeed?.notificationName, object: nil)
        FeedFactory.instance().activateHashtagFeed(hashtagFeed!)
        reloadFeed()
        //followedTags = hashtagFeed!.toArray()
    }
    
    // #pragma mark - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "hoopButtonToHashtagDetailViewSegue"{
            let vc = segue.destinationViewController as HashtagDetailTableViewController
            let cell = sender as HoopsTableCell
            vc.hashtag = cell.hashtag
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set table row height
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //load feed cell
        var nipName=UINib(nibName: "HoopsTableCell", bundle:nil)
        self.tableView.registerNib(nipName, forCellReuseIdentifier: "hoopsCell")
        hashtagFeed = FeedFactory.instance().followedHashtagFeed()
       
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        followedButtonTapped(followedButton)
    }
    
    override func viewWillDisappear(animated: Bool) {
        hashtagFeed!.unsubscribe()
    }
    
    func didReceiveLocationPermissionNeededNotification(note: NSNotification){
        displayModalDialog(
            title:      "Location Permission Needed",
            message:    "In order to use this functionality the app needs your permission to use location data - do you want to give this permission now?",
            yesHandler: {
                (action: UIAlertAction!) in LocationHelper.instance().askForPermission()
            },
            noHandler: nil
        )
    }

    
    
    //Tableview
    
    func reloadFeed(){
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hashtagFeed!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("hoopsCell", forIndexPath: indexPath) as HoopsTableCell
        let hashtag = hashtagFeed!.toArray()[indexPath.row]

        if hashtag.title == "cup"{
            NSLog("cup")
        }
        
        cell.loadItem(hashtag, viewController:self)
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
    }
    
}