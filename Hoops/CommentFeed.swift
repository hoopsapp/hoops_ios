//
//  CommentFeed.swift
//  Hoops
//
//  Created by Daniel on 25.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class CommentFeed : Feed{
    var notificationName = "comment_feed_changed"
    var comments    : [Comment] = [Comment]()
    
    var feedFilter : FeedFilter<Comment> = TimeSorter<Comment>(reverse: true)
    
    var count: Int{
        return comments.count
    }
    
    override init(client: MeteorClient) {
        super.init(client: client)
    }
    
    override func subscribe() {
        if(!active){
            notifCenter.addObserver(self, selector: "didReceiveCommentAddedUpdate:", name: "comments_added", object: nil)
            notifCenter.addObserver(self, selector: "didReceiveCommentRemovedUpdate:", name: "comments_removed", object: nil)
            notifCenter.addObserver(self, selector: "didReceiveCommentChangedUpdate:", name: "comments_changed", object: nil)
        }
        super.subscribe()
    }
    
    override func unsubscribe() {
        if(!active){
            notifCenter.removeObserver(self)
        }
        super.unsubscribe()
    }
    
    override func increaseLimit() {
        super.increaseLimit()
        subscribe()
    }
    
    func toArray()->[Comment]{
        return comments
    }
    
    func syncCollection(collection : NSMutableArray){
        comments = [Comment]()
        for element in collection{
            let comment = Comment(jsonComment:Schema.commentFrom(element))
            alterElementBeforeAdding(comment)
            comments.append(comment)
        }
        notifCenter.postNotificationName(notificationName, object: self)
    }
    
    func alterElementBeforeAdding(comment:Comment){
        
    }
    
    func didReceiveCommentAddedUpdate(note: NSNotification){
        var response = HoopsClient.instance().collections["comments"] as NSMutableArray
        syncCollection(response)
    }
    
    func didReceiveCommentChangedUpdate(note: NSNotification){
        var response = HoopsClient.instance().collections["comments"] as NSMutableArray
        syncCollection(response)
    }
    
    func didReceiveCommentRemovedUpdate(note: NSNotification){
        var response = HoopsClient.instance().collections["comments"] as NSMutableArray
        syncCollection(response)
    }
}