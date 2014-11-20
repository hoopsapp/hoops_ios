//
//  PostDetailViewController.swift
//  Hoops
//
//  Created by Joe on 08.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKit

class PostDetailViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    @IBOutlet var tableView: UITableView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var hashtagButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var postLabel: UILabel!
    @IBOutlet var noCommentsButton: UIButton!
    @IBOutlet var noCommentsLabel: UILabel!
    @IBOutlet var noLikesButton: UIButton!
    @IBOutlet var noLikesLabel: UILabel!
    @IBOutlet var letterCounterLabel: UILabel!
    //@IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var commentField: UITextField!
    @IBOutlet var grayBoxToBottomConstraint: NSLayoutConstraint!
    
    var post    :Post?
    var feed    :PostBasedCommentFeed?
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        var commentObj = Comment(text:commentField.text, postId: post!.id)
        commentObj.saveToDb()
        commentField.resignFirstResponder()
        commentField.text = ""
    }
    
    @IBAction func handleRecoginzer(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func reportButtonTapped(sender: AnyObject) {
        post!.flag()
    }
    
    @IBAction func noLikesButtonTapped(sender: AnyObject) {
        post!.like()
    }
    
    @IBAction func noCommentsButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func rehashButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("postDetailViewToWriteViewSegue", sender: self)
    }
    
    @IBAction func hashtagButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("hashtagButtonToHashtagDetailViewSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        
        //load feed cell
        var nipName = UINib(nibName: "CommentTableCell", bundle:nil)
        self.tableView.registerNib(nipName, forCellReuseIdentifier: "commentCell")

        var activityTime    = ActivityTime(timestamp:post!.createdOrUpdatedAt)
        userLabel.text      = post!.owner.1
        timeLabel.text      = activityTime.toString()
        postLabel.text      = post!.text
        noLikesLabel.text   = String(post!.likeCount)
        noCommentsLabel.text = String(post!.commentCount)
        hashtagButton.setTitle("#"+post!.hashtag.1, forState: UIControlState.Normal)

        //init feed
        let factory = FeedFactory.instance()
        feed = factory.postBasedCommentFeed(post!)
        
        //subscribe to feed changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadFeed:", name: feed!.notificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasHidden:", name:UIKeyboardWillHideNotification, object: nil);
        
        commentField.delegate = self
    }

    
    override func viewWillAppear(animated: Bool) {
        FeedFactory.instance().activateCommentFeed(feed!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        feed!.unsubscribe()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.grayBoxToBottomConstraint.constant = keyboardFrame.size.height - 50
        })
    }
    
    func keyboardWasHidden(notification: NSNotification) {
        self.grayBoxToBottomConstraint.constant = 0
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var noOfAllowedLetters : Int = 140
        var newLength : Int
        newLength = textField.text.utf16Count + string.utf16Count - range.length
        letterCounterLabel.text = String(noOfAllowedLetters - newLength)
        
        if (newLength >= noOfAllowedLetters) {
            letterCounterLabel.textColor = UIColor.redColor()
            return false
        } else {
            letterCounterLabel.textColor = UIColor.whiteColor()
            return true
        }
    }
    
    func reloadFeed(note: NSNotification){
        tableView.reloadData()
    }
    
    
    // #pragma mark - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "hashtagButtonToHashtagDetailViewSegue"{
            let vc = segue.destinationViewController as HashtagDetailTableViewController
            vc.hashtag = Hashtag(id:post!.hashtag.0, title:post!.hashtag.1)
        }
        
        if segue.identifier == "postDetailViewToWriteViewSegue"{
            let vc = segue.destinationViewController as WritePostViewController
            vc.sharedPost = post!
        }
        
        if segue.identifier == "backButtonToFeedViewSegue"{
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed!.toArray().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as CommentTableCell
        cell.loadItem(feed!.toArray()[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    
}