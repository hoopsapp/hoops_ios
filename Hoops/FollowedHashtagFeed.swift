//
//  FollowedHashtagFeed.swift
//  Hoops
//
//  Created by Daniel on 03.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class FollowedHashtagFeed: HashtagFeed{
    override init(client: MeteorClient) {
        super.init(client: client)
        notificationName = "followed_hashtag_feed_changed"
        feedFilter = TitleSorter<Hashtag>()
    }
    
    override func subscribe(){
        if(!active){
            if(limit > 0){
                client.addSubscription("followedHashtags", withParameters: ["", limit])
            }else{
                client.addSubscription("followedHashtags", withParameters: [""])
            }
        }
        super.subscribe()
    }
    
    override func alterElementBeforeAdding(hashtag:Hashtag){
        hashtag.followedByUser = true
    }
    
    override func unsubscribe(){
        if(active){
            client.removeSubscription("followedHashtags")
        }
        super.unsubscribe()
    }
    
}