//
//  PhotoViewController.swift
//  Hoops
//
//  Created by Joe on 16.10.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKIT

class PhotoViewController: ViewController{
    
    @IBOutlet var photoButton: UIButton!
    @IBOutlet var buttonWidth: NSLayoutConstraint!
    @IBOutlet var buttonHeight: NSLayoutConstraint!
    @IBOutlet var photoImageView: UIImageView!
    var image : Media?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notifCenter.addObserver(self, selector: "displayImage:", name: image!.kFileDownloadedNotification, object: nil)
        image!.download()

    }
    
    func displayImage(note: NSNotification){
        let imageObj = UIImage(data: image!.file!)
        photoButton.setBackgroundImage(imageObj, forState: UIControlState.Normal)
    }
    
}