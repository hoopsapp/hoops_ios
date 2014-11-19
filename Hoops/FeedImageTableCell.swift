//
//  FeedTableCell.swift
//  Hooptest
//
//  Created by Daniel on 16.07.14.
//  Copyright (c) 2014 Hoop Inc. All rights reserved.
//

import UIKit

class FeedImageTableCell : FeedTableCell {
    @IBOutlet var photoButton: UIButton!
    var photoData: UIImage!
    
    @IBAction func photoTapped(sender: AnyObject) {
        //viewController!.performSegueWithIdentifier("feedToVideoViewSegue", sender: self)
        
        if(post!.type == Post.PostType.Image){
            viewController!.performSegueWithIdentifier("photoButtonToUIImageViewSegue", sender: self)
        }
        else {
            viewController!.performSegueWithIdentifier("feedToVideoViewSegue", sender: self)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadItem(post:Post, viewController: UIViewController) {
        super.loadItem(post, viewController: viewController)
        if(post.type == Post.PostType.Image){
            let imageFile   = UIImage(named: "placeholder.png")
            photoButton.setBackgroundImage(imageFile, forState: UIControlState.Normal)
            }
        
        if(post.type == Post.PostType.Video){
                let imageFile   = UIImage(named: "placeholder_video.png")
                photoButton.setBackgroundImage(imageFile, forState: UIControlState.Normal)
            }
        }
        //TODO: change image to real placeholder image
        //TODO: cell height is too high if no image is attached (always same height)
}