//
//  HoopsTableCell.swift
//  Hoops
//
//  Created by Joe on 26.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKit

class HoopsTableCell : UITableViewCell{
    //@IBOutlet var hoopLabel: UILabel!
    @IBOutlet var hoopButton: UIButton!
    @IBOutlet var followButton: UIButton!
    
    var hoopId: String  = ""
    var hashtag : Hashtag?
    var viewController : UIViewController?
    
    
    @IBAction func hoopsButtonTapped(sender: AnyObject) {
        viewController!.performSegueWithIdentifier("hoopButtonToHashtagDetailViewSegue", sender: self)
    }
    
    @IBAction func followButtonTapped(sender: AnyObject) {
        hashtag!.follow()
        hashtag!.followedByUser = !hashtag!.followedByUser
        followButton.selected   = !followButton.selected
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTranslatesAutoresizingMaskIntoConstraints(true)
    }
    
    func loadItem(hashtag:Hashtag, viewController: UIViewController) {
        self.viewController = viewController
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveHashtagChangedNotification:", name: hashtag.kItemChangedNotification, object: hashtag)
        
        let hoopImage           = UIImage(named: "hoops_own.png")
        let hoopSelectedImage   = UIImage(named: "hoop_btn-14.png")
        followButton.showsTouchWhenHighlighted = true
        followButton.setImage(hoopImage, forState: UIControlState.Normal)
        followButton.setImage(hoopSelectedImage, forState: UIControlState.Selected)
        
        updateCell(hashtag)
    }
    
    func updateCell(hashtag:Hashtag){
        self.hashtag            = hashtag
        followButton.selected   = hashtag.followedByUser
        hoopButton.setTitle("#"+hashtag.title, forState: UIControlState.Normal)
    }
    
    func didReceiveHashtagChangedNotification(note: NSNotification){
        let hashtag = note.object as Hashtag
        updateCell(hashtag)
    }
    

}