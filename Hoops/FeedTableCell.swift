//
//  FeedTableCell.swift
//  Hooptest
//
//  Created by Daniel on 16.07.14.
//  Copyright (c) 2014 Hoop Inc. All rights reserved.
//

import UIKit

class FeedTableCell : PostTableCell {
    @IBOutlet var hoopButton: UIButton!
    @IBOutlet var postText: UILabel!
   
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func rehashButtonTapped(sender: AnyObject) {
        viewController!.performSegueWithIdentifier("feedCellToWritePostViewSegue", sender: self)
    }

    @IBAction func hoopButtonTapped(sender: AnyObject) {
        viewController!.performSegueWithIdentifier("hashtagButtonToHashtagDetailViewSegue", sender: self)
    }
    
    override func loadItem(post:Post, viewController: UIViewController) {
        super.loadItem(post, viewController: viewController)
        hoopButton.setTitle("#"+post.hashtag.1, forState: UIControlState.Normal)
        
        /*
        if(post.type == Post.PostType.Image){
            let imageFile   = UIImage(named: "placeholder.png")
            photoButton.setBackgroundImage(imageFile, forState: UIControlState.Normal)
            }
        
        if(post.type == Post.PostType.Video){
                let imageFile   = UIImage(named: "placeholder_video.png")
                photoButton.setBackgroundImage(imageFile, forState: UIControlState.Normal)
            }
        */
    } 
}