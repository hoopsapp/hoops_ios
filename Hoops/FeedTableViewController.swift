//
//  FeedTableViewController.swift
//  Hooptest
//
//  Created by Joe on 19.08.14.
//  Copyright (c) 2014 Hoop Inc. All rights reserved.
//

import UIKit

class FeedTableViewController: PostFeedController{
    //var buttonToHashtagDetailViewControllerSegue: UIStoryboardSegue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load feed cell
        var nipName=UINib(nibName: "FeedTableCell", bundle:nil)
        self.tableView.registerNib(nipName, forCellReuseIdentifier: "feedCell")
        
        nipName=UINib(nibName: "FeedImageTableCell", bundle:nil)
        self.tableView.registerNib(nipName, forCellReuseIdentifier: "feedImageCell")
        
        //init feed
        let factory = FeedFactory.instance()
        feed = factory.hashtagBasedPostFeed(factory.followedHashtagFeed())
        
        //subscribe to feed changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadFeed:", name: feed!.notificationName, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool){
        let hbFeed = feed! as HashtagBasedPostFeed
        hbFeed.notifyView = false
        FeedFactory.instance().activatePostFeed(hbFeed)
        FeedFactory.instance().activateHashtagFeed(hbFeed.hashtagFeed)
        hbFeed.notifyView = true
        NSLog(HoopsClient.instance().collections.description)
    }

    override func viewWillDisappear(animated: Bool) {
        let hbFeed = feed! as HashtagBasedPostFeed
        hbFeed.unsubscribe()
        hbFeed.hashtagFeed.unsubscribe()
    }
    
    // #pragma mark - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "bubbleFeedCellToPostDetailViewSegue"{
            let vc = segue.destinationViewController as PostDetailViewController
            let feedCell = sender as PostTableCell
            vc.post = feedCell.post
            return
        }
        
        if segue.identifier == "feedCellToPostDetailViewSegue"{
            let vc = segue.destinationViewController as PostDetailViewController
            let indexPath = sender! as NSIndexPath
            vc.post = feed!.toArray()[indexPath.row]
            return
        }

        if segue.identifier == "hashtagButtonToHashtagDetailViewSegue"{
            let vc = segue.destinationViewController as HashtagDetailTableViewController
            let cell = sender as FeedTableCell
            vc.hashtag = Hashtag(id:cell.post!.hashtag.0, title:cell.post!.hashtag.1)
            return
        }
        
        if segue.identifier == "feedCellToWritePostViewSegue"{
            let vc = segue.destinationViewController as WritePostViewController
            let cell = sender as FeedTableCell
            vc.sharedPost = cell.post!
            return
        }
        
        if segue.identifier == "feedViewToWritePostViewSegue"{
            let vc = segue.destinationViewController as WritePostViewController
            //let cell = sender as FeedTableCell
            //vc.sharedPost = cell.post!
            return
        }
        
        if segue.identifier == "feedViewToHashtagSucheViewSegue"{
            let vc = segue.destinationViewController as HashtagSucheTableViewController
            return
        }
        
        if segue.identifier == "photoButtonToUIImageViewSegue"{
            let vc = segue.destinationViewController as PhotoViewController
            let cell   = sender! as FeedTableCell
            let post   = cell.post!
            vc.image   = Media(filename: post.file!, type: post.type)
            return
        }
        
        if segue.identifier == "feedToVideoViewSegue"{
            let vc = segue.destinationViewController as VideoViewController
            return
        }
    }
    
   
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("feedCellToPostDetailViewSegue", sender:indexPath)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellType :String
        let post = feed!.toArray()[indexPath.row]
        
        if(post.type == Post.PostType.Image || post.type == Post.PostType.Video){
            cellType = "feedImageCell"
        }else{
            cellType = "feedCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellType, forIndexPath: indexPath) as FeedTableCell
        cell.selectionStyle = .None
        cell.loadItem(post, viewController:self)
        
        // set button's target
        cell.hoopButton.addTarget(self, action: Selector("push:"), forControlEvents: .TouchUpInside)
        return cell
    }
}

