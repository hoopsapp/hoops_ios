//
//  WritePostViewController.swift
//  Hoops
//
//  Created by Joe on 08.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKIT
import MobileCoreServices

class WritePostViewController: ViewController, UINavigationControllerDelegate,    UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    var tag         : String    = ""
    var post        : String    = ""
    var image       : UIImage?
    var video       : NSURL?
    var fileType    : String?
    var feednavi = FeedNavigationViewController()
    
    @IBOutlet var photoImageToBottomConstraint: NSLayoutConstraint!
    @IBOutlet var sendImageToBottomConstraint: NSLayoutConstraint!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tagLabel: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var postLabel: UITextView!
    @IBOutlet var hashtagCounter: UILabel!
    @IBOutlet var postCounter: UILabel!
    
    @IBOutlet var thumbnail: UIImageView!
    
    var sharedPost : Post?
    var selectedHashtag: Hashtag?

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var noOfAllowedLetters : Int = 140
        var newLength : Int
        
        newLength = textView.text.utf16Count + text.utf16Count - range.length
        postCounter.text = String(noOfAllowedLetters - newLength)
        
        
        if (newLength >= noOfAllowedLetters) {
            postCounter.textColor = UIColor.redColor()
            return false
        } else {
            postCounter.textColor = UIColor.grayColor()
            return true
        }
        
        /*
        var remainingLetters: Int
        
        if(text == ""){
            postLetterCounter = postLetterCounter - 1
        } else {
            postLetterCounter = postLetterCounter + 1
        }
        
        remainingLetters = 120 - postLetterCounter
        hashtagCounter.text = String(remainingLetters)
        
        if(remainingLetters <= 0 ){
            hashtagCounter.textColor = UIColor.redColor()
        } else {
            hashtagCounter.textColor = UIColor.grayColor()
        }
        return true
        */
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var noOfAllowedLetters : Int = 20
        var newLength : Int
        newLength = textField.text.utf16Count + string.utf16Count - range.length
        hashtagCounter.text = String(noOfAllowedLetters - newLength)
        
        if (newLength >= noOfAllowedLetters) {
            hashtagCounter.textColor = UIColor.redColor()
            return false
        } else {
            hashtagCounter.textColor = UIColor.grayColor()
            return true
        }
        
        /*
        var remainingLetters: Int
        
        if(string == ""){
        hashtagLetterCounter = hashtagLetterCounter - 1
        } else {
        hashtagLetterCounter = hashtagLetterCounter + 1
        }
        
        remainingLetters = 20 - hashtagLetterCounter
        hashtagCounter.text = String(remainingLetters)
        
        if(remainingLetters <= 0 ){
        hashtagCounter.textColor = UIColor.redColor()
        } else {
        hashtagCounter.textColor = UIColor.grayColor()
        }
        return true
        }
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
        if let post = sharedPost{
            postLabel.text = post.text
        }
        
        if let hashtag = selectedHashtag{
            tagLabel.text = hashtag.title
        }
        
        // set delegate of tabLabel for Counting
        tagLabel.delegate = self
        postLabel.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasHidden:", name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func keyboardWasShown(notification: NSNotification) {
        println("keyboard was shown()")
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.photoImageToBottomConstraint.constant = keyboardFrame.size.height - 40
            self.sendImageToBottomConstraint.constant = keyboardFrame.size.height - 40
        })
    }
    
    func keyboardWasHidden(notification: NSNotification) {
        println("keyboard was hidden()")
        self.photoImageToBottomConstraint.constant = 20
        self.sendImageToBottomConstraint.constant = 20
    }
    
    
    // #pragma mark - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "writePostViewToFeedViewControllerSegue"{
            let vc = segue.destinationViewController as FeedTableViewController
            return
        }
    }
    
    @IBAction func uploadButtonTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            var mediaController = UIImagePickerController()
            mediaController.delegate        = self
            mediaController.allowsEditing   = true
            mediaController.sourceType      = UIImagePickerControllerSourceType.Camera;
            mediaController.mediaTypes.append(kUTTypeImage)
            mediaController.mediaTypes.append(kUTTypeMovie)
            
            self.presentViewController(mediaController, animated: true, completion: nil)
        }
    }
    
    @IBAction func sendTapped(sender: AnyObject) {
        activityIndicator.startAnimating()
        
        tag = tagLabel.text as NSString
        post = postLabel.text as NSString
        
        //if(validateHashtag(tag) && validatePost(post, hasFile: (fileUrl != nil))){
            if fileType != nil{
                var media : Media
                if fileType == (kUTTypeImage as NSString){
                    media = Media(file:NSData(data:UIImagePNGRepresentation(image)), type:Post.PostType.Image)
                }else{
                    let videoData = NSData(contentsOfMappedFile: video!.path!)
                    media = Media(file: videoData!, type:Post.PostType.Video)
                }

                notifCenter.addObserver(self, selector: "savePost:", name: media.kFileUploadedNotification, object: nil)
                media.upload()
            }
            else{
                savePost(nil)
            }
        //}else{
          //  displaySimpleAlert(title: "Validation Error", message: "Validation Error")
        //}
    }

    func savePost(note: NSNotification?){
        var fileKey : String?
        var type    : Post.PostType = Post.PostType.Text
        
        if let notification = note{
            let media   = notification.object as Media
            fileKey     = media.filename
            type        = media.type
        }
        
        var location    = LocationHelper.instance().location
        var user        = User.currentUser()
        var postObj     = Post(
            owner:      (user.id, user.name),
            text:       post,
            hashtag:    ("", tag),
            type:       type,
            location:   location,
            file:       fileKey
        )
        postObj.saveToDb()
        
        self.activityIndicator.stopAnimating()
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        fileType    = (info[UIImagePickerControllerMediaType]! as String)
        
        if fileType == (kUTTypeImage as NSString){      //is Image
            image     = Media.scaleImage((info[UIImagePickerControllerEditedImage] as UIImage))
            thumbnail.image = image
        }else{                                          //is Movie
            video     = (info[UIImagePickerControllerMediaURL] as NSURL)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
  
    
    func validateHashtag(hashtag:String)->Bool{
        if(countElements(hashtag) > kMaxHashtagLength){
            return false
        }
        
        if(countElements(hashtag) == 0){
            return false
        }
        
        return true
    }
    
    
    func validatePost(post:String, hasFile: Bool)->Bool{
        //post must not exceed max length
        if(countElements(post) > kMaxPostLength){
            return false
        }
        
        //post must have at least length 1 if no file is attached
        if(countElements(post) == 0 && !hasFile){
            return false
        }
        
        return true
    }
}
