//
//  FeedTableCell.swift
//  Hooptest
//
//  Created by Daniel on 16.07.14.
//  Copyright (c) 2014 Hoop Inc. All rights reserved.
//

import UIKit

class HashtagDetailTableCell : PostTableCell {

    @IBAction func rehashButtonTapped(sender: AnyObject) {
        viewController!.performSegueWithIdentifier("hashtagDetailViewToWriteViewSegue", sender: self)
    }
}