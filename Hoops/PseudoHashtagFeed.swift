//
//  PseudoHashtagFeed.swift
//  Hoops
//
//  Created by Daniel on 07.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class PseudoHashtagFeed: HashtagFeed{
    
    override init(client: MeteorClient) {
        super.init(client: client)
        
    }
    
    init(hashtag:Hashtag) {
        super.init(client: HoopsClient.instance())
        notificationName = "pseudo_hashtag_feed_changed"
        hashtags.append(hashtag)
    }
    
    override func subscribe(){
        if(!active){
            active = true
            NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: self)
        }

    }
    
    override func increaseLimit() {
        return
    }
    
    override func unsubscribe(){
        if(active){
            active = false
        }
    }
}