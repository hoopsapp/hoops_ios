//
//  FeedFactory.swift
//  Hoops
//
//  Created by Daniel on 05.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

let _feedFactory = FeedFactory()

class FeedFactory{
    var client          : HoopsClient   = HoopsClient.instance()

    var _followedHashtagFeed : FollowedHashtagFeed?
    var _nearbyHashtagFeed   : NearbyHashtagFeed?
    var _hottestHashtagFeed  : HottestHashtagFeed?
    
    var _hashtagBasedPostFeeds    : [HashtagFeed:HashtagBasedPostFeed]  = [HashtagFeed:HashtagBasedPostFeed]()
    var _postBasedCommentFeeds    : [Post:PostBasedCommentFeed]         = [Post:PostBasedCommentFeed]()

    class func instance() -> FeedFactory{
        return _feedFactory
    }
    
    init(){
    }
    
    func unsubscribeHashtags(){
        _followedHashtagFeed?.unsubscribe()
        _nearbyHashtagFeed?.unsubscribe()
        _hottestHashtagFeed?.unsubscribe()
    }
    
    func unsubscribePosts(){
        for (i, feed) in _hashtagBasedPostFeeds{
            feed.unsubscribe()
        }
    }
    
    func unsubscribeComments(){
        for (i, feed) in _postBasedCommentFeeds{
            feed.unsubscribe()
        }
    }
    
    func activateHashtagFeed(feed: HashtagFeed){
        if(feed.active) {return}        
        
        unsubscribeHashtags()
        feed.subscribe()
    }
    
    func activatePostFeed(feed: PostFeed){
        if(feed.active) {return}
        
        unsubscribePosts()
        feed.subscribe()
    }
    
    func activateCommentFeed(feed: CommentFeed){
        if(feed.active) {return}
        
        unsubscribeComments()
        feed.subscribe()
    }
    
    func followedHashtagFeed()->FollowedHashtagFeed{
        var result:FollowedHashtagFeed
        
        if let feed = _followedHashtagFeed{
            result = feed
        }
        else{
            _followedHashtagFeed = FollowedHashtagFeed(client:client)
            result = _followedHashtagFeed!
        }
        
        if(!result.active){
            unsubscribeHashtags()
        }
        return result
    }

    func nearbyHashtagFeed()->NearbyHashtagFeed{
        var result:NearbyHashtagFeed
        
        if let feed = _nearbyHashtagFeed{
            result = feed
        }
        else{
            _nearbyHashtagFeed = NearbyHashtagFeed(client:client)
            result = _nearbyHashtagFeed!
        }
        
        if(!result.active){
            unsubscribeHashtags()
        }
        return result
    }
    
    func hottestHashtagFeed()->HottestHashtagFeed{
        var result:HottestHashtagFeed
        
        if let feed = _hottestHashtagFeed{
            result = feed
        }
        else{
            _hottestHashtagFeed = HottestHashtagFeed(client:client)
            result = _hottestHashtagFeed!
        }
        
        if(!result.active){
            unsubscribeHashtags()
        }
        return result
    }
    
    func pseudoHashtagFeed(hashtag:Hashtag)->PseudoHashtagFeed{
        return PseudoHashtagFeed(hashtag:hashtag)
    }
    
    func hashtagBasedPostFeed(hashtagFeed:HashtagFeed)->HashtagBasedPostFeed{
        var result:HashtagBasedPostFeed
        
        if let feed = _hashtagBasedPostFeeds[hashtagFeed]{
            result = feed
        }
        else{
            _hashtagBasedPostFeeds[hashtagFeed] = HashtagBasedPostFeed(client:client, hashtagFeed:hashtagFeed)
            result = _hashtagBasedPostFeeds[hashtagFeed]!
        }
        
        if(!result.active){
            unsubscribePosts()
        }

        return result
    }
    
    func postBasedCommentFeed(post:Post)->PostBasedCommentFeed{
        var result:PostBasedCommentFeed
        
        if let feed = _postBasedCommentFeeds[post]{
            result = feed
        }
        else{
            _postBasedCommentFeeds[post] = PostBasedCommentFeed(client:client, post:post)
            result = _postBasedCommentFeeds[post]!
        }
        
        if(!result.active){
            unsubscribeComments()
        }
        return result
    }
}