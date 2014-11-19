//
//  VideoViewController.swift
//  Hoops
//
//  Created by Joe on 16.10.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKIT
import MediaPlayer
import MobileCoreServices

class VideoViewController: ViewController, UIImagePickerControllerDelegate {
    
    var videoController : MPMoviePlayerController!
    var videoURL : NSURL!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        videoURL = NSURL(fileURLWithPath: "IMG_5764.MOV", isDirectory: false)
        videoController = MPMoviePlayerController()
        
        videoController.contentURL = videoURL
        videoController.fullscreen = true
        //videoController.view.frame(CGRectMake(0, 0, 320, 460))
        self.view.addSubview(videoController.view)
        videoController.play()
        println("läuft???")
    }
    
    
}