//
//  HottestHashtagFeed.swift
//  Hoops
//
//  Created by Daniel on 03.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class HottestHashtagFeed: HashtagFeed{
    override init(client: MeteorClient) {
        super.init(client: client)
        notificationName = "hottest_hashtag_feed_changed"
        feedFilter = HotnessSorter<Hashtag>()
    }
    
    override func subscribe(){
        if(!active){
            client.addSubscription("hottestHashtags", withParameters: ["", limit])
        }
        super.subscribe()
    }
    
    override func unsubscribe(){
        if(active){
            client.removeSubscription("hottestHashtags")
        }
        super.unsubscribe()
    }
}