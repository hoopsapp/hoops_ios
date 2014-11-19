//
//  HashtagBasedPostFeed.swift
//  Hoops
//
//  Created by Daniel on 27.07.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class HashtagBasedPostFeed:PostFeed{
    var owner               : User              = User.currentUser()
    var hashtagFeed         : HashtagFeed

    
    init(client: MeteorClient, hashtagFeed:HashtagFeed) {
        self.hashtagFeed = hashtagFeed
        self.hashtagFeed.limit =  0     //No limit to get all posts
        super.init(client: client)
    }
    
    override func subscribe() {
        if(!active){
            notifCenter.addObserver(self, selector: "didReceiveHashtagFeedUpdate:", name: hashtagFeed.notificationName, object: nil)
        }
        super.subscribe()
    }
    
    override func alterElementBeforeAdding(post: Post) {
        super.alterElementBeforeAdding(post)
        var hashtagName = ""
        if let hashtag = hashtagFeed.hashtagById(post.hashtag.0){
            hashtagName = hashtag.title
        }        
        post.hashtag = (post.hashtag.0, hashtagName)
    }
    
    override func increaseLimit() {
        if posts.count == limit{
            limit += kLimitIncrement
            didReceiveHashtagFeedUpdate(nil)
        }
    }
    
    func didReceiveHashtagFeedUpdate(note: NSNotification!){
        client.removeSubscription("posts")
        client.addSubscription("posts", withParameters: [hashtagFeed.toIdArray(), "", limit, ""])
    }
}

