//
//  HastagSucheTableViewController.swift
//  Hoops
//
//  Created by Joe on 17.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKit

class HashtagSucheTableViewController: TableViewController, UISearchBarDelegate, UISearchDisplayDelegate{
    @IBOutlet var hashtagSearchBar: UITableView!

    var autoCompletion  = AutoCompletion()
    var results         = [Hashtag]()
    var followedHashtags: FollowedHashtagFeed?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get followed tags
        followedHashtags = FeedFactory.instance().followedHashtagFeed()
        FeedFactory.instance().activateHashtagFeed(followedHashtags!)
        
        //set table row height
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //load feed cell
        var nipName=UINib(nibName: "HoopsTableCell", bundle:nil)
        self.tableView.registerNib(nipName, forCellReuseIdentifier: "hoopsCell")
        
        notifCenter.addObserver(self, selector: "updateResult:", name: autoCompletion.kAutoCompletionUpdatedNotification, object: nil)
    }
    
    // #pragma mark - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "hoopButtonToHashtagDetailViewSegue"{
            let vc = segue.destinationViewController as HashtagDetailTableViewController
            let cell = sender as HoopsTableCell
            vc.hashtag = cell.hashtag
            //Hashtag(id:cell.hashtag.0, title:cell.hashtag.1)
            return
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        autoCompletion.search(searchText)
    }
    
    func updateResult(note: NSNotification){
        results = note.object as [Hashtag]
        tableView.reloadData()
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let hashtag = results[indexPath.row]
 
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        for tag in followedHashtags!.toArray(){
            if(hashtag == tag){
                hashtag.followedByUser = true
                break
            }
        }
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("hoopsCell") as HoopsTableCell
        cell.loadItem(hashtag, viewController:self)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
}