//
//  SingleTagPostFeed.swift
//  Hoops
//
//  Created by Daniel on 07.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class SingleTagPostFeed:HashtagBasedPostFeed{
    
    init(client: MeteorClient, hashtag:Hashtag){
        super.init(client: client, hashtagFeed: FeedFactory.instance().pseudoHashtagFeed(hashtag))
    }
}