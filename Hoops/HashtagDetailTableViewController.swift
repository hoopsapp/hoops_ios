//
//  HashtagDetailTableViewController.swift
//  Hooptest
//
//  Created by Joe on 13.09.14.
//  Copyright (c) 2014 Hoop Inc. All rights reserved.
//

import UIKit

class HashtagDetailTableViewController: PostFeedController, UISearchBarDelegate, UISearchDisplayDelegate{
    var hashtag : Hashtag?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load feed cell
        var nipName=UINib(nibName: "HashtagDetailTableCell", bundle:nil)
        self.tableView.registerNib(nipName, forCellReuseIdentifier: "hashtagDetailCell")

        //init feed
        let factory = FeedFactory.instance()
        feed = factory.hashtagBasedPostFeed(factory.pseudoHashtagFeed(hashtag!))
        
        self.title = "#\(hashtag!.title)"
        //self.navigationController!.navigationBar.topItem.title =
        
        //subscribe to feed changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadFeed:", name: feed!.notificationName, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        let hbFeed = feed! as HashtagBasedPostFeed
        FeedFactory.instance().activatePostFeed(hbFeed)
        FeedFactory.instance().activateHashtagFeed(hbFeed.hashtagFeed)
    }
    
    override func viewWillDisappear(animated: Bool) {
        feed!.unsubscribe()
    }
   
    
    // #pragma mark - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       if segue.identifier == "hashtagDetailViewToWriteViewSegue"{
            let vc = segue.destinationViewController as WritePostViewController
            let cell = sender as HashtagDetailTableCell
            //vc.selectedHashtag = Hashtag(id:cell.post!.hashtag.0, title:cell.post!.hashtag.1)
            vc.sharedPost = cell.post!
        }
        if segue.identifier == "hashtagDetailViewToPostDetailViewSegue"{
            let vc = segue.destinationViewController as PostDetailViewController
            let indexPath = sender! as NSIndexPath
            vc.post = feed!.toArray()[indexPath.row]
        }
        if segue.identifier == "hashtagDetailViewToFeedViewSegue"{
            let vc = segue.destinationViewController as FeedTableViewController
        }
        
        
  
    }
    
    // #pragma mark - Table View
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("hashtagDetailViewToPostDetailViewSegue", sender:indexPath)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("hashtagDetailCell", forIndexPath: indexPath) as HashtagDetailTableCell
        cell.selectionStyle = .None
        
        let post = feed!.toArray()[indexPath.row]
        cell.loadItem(post, viewController:self)
        return cell
    }
}

