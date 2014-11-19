//
//  FollowedPostFeed.swift
//  Hoops
//
//  Created by Daniel on 27.07.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class FollowedPostFeed2:Feed{
    var posts               : [Post]            = [Post]()
    var feedFilter          : FeedFilter<Post>  = TimeSorter<Post>()
    var owner               : User              = User.currentUser()
    
    var hashtagFeed         : HashtagFeed
    
    var count : Int{
        return posts.count
    }

    init(client: MeteorClient, hashtagFeed:HashtagFeed) {
        self.hashtagFeed = hashtagFeed
        super.init(client: client)
    }
    
    override func subscribe() {
        super.subscribe()
        notifCenter.addObserver(self, selector: "didReceiveHashtagFeedUpdate:", name: hashtagFeed.notificationName, object: nil)
        notifCenter.addObserver(self, selector: "didReceivePostAddedUpdate:", name: "posts_added", object: nil)
        notifCenter.addObserver(self, selector: "didReceivePostRemovedUpdate:", name: "posts_removed", object: nil)
        notifCenter.addObserver(self, selector: "didReceivePostChangedUpdate:", name: "posts_changed", object: nil)
    }
    
    override func unsubscribe() {
        super.unsubscribe()
        notifCenter.removeObserver(self)
        //hashtagFeed.unsubscribe() //TODO: im auge behalten ob mit feed factory harmoniert
    }
    
    
    func toArray()->[Post]{
        return feedFilter.filter(posts)
    }
    
    
    //Notifications
    func didReceivePostAddedUpdate(note: NSNotification!){
        var response    : [AnyObject]
        var jsonPost    : Schema.JsonPost
        var post        : Post
        var hashtagName = ""
        
        response = HoopsClient.instance().collections["posts"] as [AnyObject]
        jsonPost = Schema.postFrom(response[response.count-1])

        if let hashtag = hashtagFeed.hashtagById(jsonPost.hashtagId){
            hashtagName = hashtag.title
        }
       
        post = Post(
            id: jsonPost.id,
            owner: (jsonPost.user["_id"]!, jsonPost.user["username"]!),
            text: jsonPost.text,
            hashtag: (jsonPost.hashtagId, hashtagName),
            type: jsonPost.type,
            createdAt: jsonPost.createdAt,
            createdOrUpdatedAt:
            jsonPost.createdOrUpdatedAt
        )

        //check if post was already received
        if find(posts, post) == nil{
            posts.append(post)
            NSLog("Post added \(post.text)")
            notifCenter.postNotificationName("post_feed_changed", object: self)
        }
    }
    
    func didReceiveHashtagFeedUpdate(note: NSNotification!){
        client.addSubscription("posts", withParameters: [hashtagFeed.toIdArray()])
    }
}

