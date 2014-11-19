//
//  FeedTableViewController.swift
//  Hooptest
//
//  Created by Joe on 19.08.14.
//  Copyright (c) 2014 Hoop Inc. All rights reserved.
//

import UIKit

class PostFeedController: FeedController {
    var feed:PostFeed?
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed!.toArray().count
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // load more posts
        feed!.increaseLimit()
    }
 }

