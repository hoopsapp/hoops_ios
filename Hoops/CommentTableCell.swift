//
//  CommentTableCell.swift
//  Hoops
//
//  Created by Joe on 08.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKit

class CommentTableCell : UITableViewCell{
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var noLikesLabel: UILabel!
    @IBOutlet var noLikesButton: UIButton!
    @IBOutlet var reportButton: UIButton!
    
    var comment : Comment?
    
    @IBAction func noLikesButtonTapped(sender: AnyObject) {
        comment!.like()
        noLikesButton.selected = !reportButton.selected
    }
    
    @IBAction func reportButtonTapped(sender: AnyObject) {
        comment!.flag()
        reportButton.selected = !reportButton.selected
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTranslatesAutoresizingMaskIntoConstraints(true)
    }
    
    func loadItem(comment:Comment) {
        self.comment = comment
       
        let activityTime = ActivityTime(timestamp: comment.createdOrUpdatedAt)
        
        // like Button appearance
        let thumbImageGray = UIImage(named: "Thumbs-Up.png")
        noLikesButton.setImage(thumbImageGray, forState: UIControlState.Normal)
        let thumbImageColored = UIImage(named: "Thumbs-Up_filled.png")
        noLikesButton.setImage(thumbImageColored, forState: UIControlState.Selected)
        
        // flag Button appearance
        let flagImageGray = UIImage(named: "flag_new.png")
        reportButton.setImage(flagImageGray, forState: UIControlState.Normal)
        let flagImageColored = UIImage(named: "flag_newpushed.png")
        reportButton.setImage(flagImageColored, forState: UIControlState.Selected)
        
        userLabel.text = comment.owner.1
        commentLabel.text = comment.text
        noLikesLabel.text = String(comment.likeCount)
        timeLabel.text = activityTime.toString()
    }
}