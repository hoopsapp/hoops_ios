//
//  FeedTableCell.swift
//  Hooptest
//
//  Created by Daniel on 16.07.14.
//  Copyright (c) 2014 Hoop Inc. All rights reserved.
//

import UIKit

class PostTableCell : UITableViewCell {
    @IBOutlet var userLabel         : UILabel!
    @IBOutlet var postLabel         : UILabel!
    @IBOutlet var timeLabel         : UILabel!
    @IBOutlet var noCommentsLabel   : UILabel!
    @IBOutlet var noLikesLabel      : UILabel!
    @IBOutlet var noCommentsButton  : UIButton!
    @IBOutlet var noLikesButton     : UIButton!
    @IBOutlet var rehashButton      : UIButton!
    @IBOutlet var reportButton      : UIButton!
    
    var viewController : UIViewController?
    var post : Post?
    
    @IBAction func bubbleButtonTapped(sender: AnyObject) {
        viewController!.performSegueWithIdentifier("bubbleFeedCellToPostDetailViewSegue", sender: self)
    }
    
    @IBAction func reportButtonTapped(sender: AnyObject) {
        post!.flag()
        reportButton.selected = !reportButton.selected
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTranslatesAutoresizingMaskIntoConstraints(true)
    }
    
    @IBAction func noCommentsButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func noLikesButtonTapped(sender: AnyObject) {
        post!.like()
    }
    
    func loadItem(post:Post, viewController: UIViewController) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceivePostChangedNotification:", name: post.kItemChangedNotification, object: post)

        // like Button appearance
        let thumbImageGray = UIImage(named: "Thumbs-Up.png")
        let thumbImageColored = UIImage(named: "Thumbs-Up_filled.png")
        noLikesButton.setImage(thumbImageGray, forState: UIControlState.Normal)
        noLikesButton.setImage(thumbImageColored, forState: UIControlState.Selected)
        
        // flag Button appearance
        let flagImageGray = UIImage(named: "flag_new.png")
        let flagImageColored = UIImage(named: "flag_newpushed.png")
        reportButton.setImage(flagImageGray, forState: UIControlState.Normal)
        reportButton.setImage(flagImageColored, forState: UIControlState.Selected)
        
        self.viewController = viewController
        updateCell(post)
    }
    
    func updateCell(post:Post){
        self.post = post

        let activityTime     = ActivityTime(timestamp: post.createdOrUpdatedAt)
        userLabel.text       = post.owner.1
        postLabel.text       = post.text
        noLikesLabel.text    = String(post.likeCount)
        timeLabel.text       = activityTime.toString()
        noCommentsLabel.text = String(post.commentCount)
        noLikesButton.selected = post.likedByUser
    }
    
    func didReceivePostChangedNotification(note: NSNotification){
        let post = note.object as Post
        updateCell(post)
    }
    
}