//
//  PostBasedCommentFeed.swift
//  Hoops
//
//  Created by Daniel on 27.07.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class PostBasedCommentFeed:CommentFeed{
    var post         : Post
    
    init(client: MeteorClient, post:Post) {
        self.post = post
        super.init(client: client)
    }
    
    override func subscribe() {
        if(!active){
            client.addSubscription("comments", withParameters: [post.id, limit])
        }
        super.subscribe()
    }
    
    override func unsubscribe() {
        if(!active){
            client.removeSubscription("comments")
        }
        super.unsubscribe()
    }
    
    
    override func alterElementBeforeAdding(comment: Comment) {

    }
   
}

