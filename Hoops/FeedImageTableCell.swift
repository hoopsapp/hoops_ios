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
    var mediaFile: Media?
    
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
            
            //download image
            mediaFile = Media(filename: post.file!, type: post.type)
            notifCenter.addObserver(self, selector: "displayImage:", name: mediaFile!.kFileDownloadedNotification, object: mediaFile!)
            mediaFile!.download()
        }
        
        if(post.type == Post.PostType.Video){
                let imageFile   = UIImage(named: "placeholder_video.png")
                photoButton.setBackgroundImage(imageFile, forState: UIControlState.Normal)
        }
    }

    func displayImage(note: NSNotification){
        if let file = mediaFile!.file{
            let imageObj = UIImage(data: mediaFile!.file!)
            photoButton.setBackgroundImage(imageObj, forState: UIControlState.Normal)
        }
    }
}