//
//  PostFeed.swift
//  Hoops
//
//  Created by Daniel on 25.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class PostFeed : Feed{
    var notificationName: String            = "post_feed_changed"
    var posts           : [Post]            = [Post]()
    var feedFilter      : FeedFilter<Post>  = TimeSorter<Post>()
    
    var notifyView      : Bool              = true{
        didSet{
            if(notifyView == true){
                notifCenter.postNotificationName(notificationName, object: self)
            }
        }
    }
    
    var count: Int{
        return posts.count
    }
    
    override init(client: MeteorClient) {
        super.init(client: client)
    }
    
    override func subscribe() {
        if(!active){
            notifCenter.addObserver(self, selector: "didReceivePostAddedUpdate:", name: "posts_added", object: nil)
            notifCenter.addObserver(self, selector: "didReceivePostRemovedUpdate:", name: "posts_removed", object: nil)
            notifCenter.addObserver(self, selector: "didReceivePostChangedUpdate:", name: "posts_changed", object: nil)
        }
        super.subscribe()
    }
    
    override func unsubscribe() {
        if(active){
            notifCenter.removeObserver(self)
        }
        super.unsubscribe()
    }
    
    override func increaseLimit(){
        if posts.count == limit{
            limit += kLimitIncrement
        }
    }
    
    func toArray()->[Post]{
        return feedFilter.filter(posts)
    }
    
    func syncCollection(collection : NSMutableArray){
        
        posts = [Post]()
        for element in collection{
            let post = Post(jsonPost:Schema.postFrom(element))
            alterElementBeforeAdding(post)
            posts.append(post)
        }
        if (notifyView){
            notifCenter.postNotificationName(notificationName, object: self)
        }
    }
    
    func alterElementBeforeAdding(post:Post){
        //get comment count
        let countCollection = HoopsClient.instance().collections["counts"] as NSMutableArray
        let commentCount    = Schema.commentCountFrom(countCollection, postId: post.id)
        post.commentCount = commentCount.count
        
        //get like status
        let likeCollection = HoopsClient.instance().collections as NSMutableDictionary
        let user = User.currentUser()
        post.likedByUser = user.hasLiked(post)
    }
    
    func didReceivePostAddedUpdate(note: NSNotification){
        var response        = HoopsClient.instance().collections["posts"] as NSMutableArray
        syncCollection(response)
    }
    
    func didReceivePostChangedUpdate(note: NSNotification){
        let post    = Post(jsonPost:Schema.postFrom(note.userInfo!))
        alterElementBeforeAdding(post)
        for (i, p) in enumerate(posts){
            if(p == post){
                posts[i].updateFromPost(post)
                break
            }
        }
    }
    
    func didReceivePostRemovedUpdate(note: NSNotification){
        var response = HoopsClient.instance().collections["posts"] as NSMutableArray
        syncCollection(response)
    }
    
    
    func didReceiveCommentAddedUpdate(note: NSNotification){
        NSLog(note.description)
    }
}