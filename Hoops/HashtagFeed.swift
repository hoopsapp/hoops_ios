//
//  HashtagFeed.swift
//  Hoops
//
//  Created by Daniel on 25.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class HashtagFeed : Feed{
    var notificationName = "hashtag_feed_changed"
    var hashtags    : [Hashtag] = [Hashtag]()
    
    var feedFilter : FeedFilter<Hashtag> = TimeSorter<Hashtag>()
    
    var count: Int{
        return hashtags.count
    }
        
    override init(client: MeteorClient) {
        super.init(client: client)
    }
    
    override func subscribe() {
        if(!active){
            notifCenter.addObserver(self, selector: "didReceiveHashtagAddedUpdate:", name: "hashtags_added", object: nil)
            notifCenter.addObserver(self, selector: "didReceiveHashtagRemovedUpdate:", name: "hashtags_removed", object: nil)
            notifCenter.addObserver(self, selector: "didReceiveHashtagChangedUpdate:", name: "hashtags_changed", object: nil)
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
        if hashtags.count == limit{
            limit += kLimitIncrement
            subscribe()
        }
    }
    
    func toArray()->[Hashtag]{
        return feedFilter.filter(hashtags)
    }
    
    func toIdArray()->[String]{
        var ids = [String]()
        for hashtag in hashtags{
            ids.append(hashtag.id)
        }
        return ids
    }
    
    func hashtagById(id:String)->Hashtag?{
        for hashtag in hashtags{
            if(hashtag.id == id){
                return hashtag
            }
        }
        return nil
    }
    
    func syncCollection(collection : NSMutableArray){
        hashtags = [Hashtag]()
        for element in collection{
            let hashtag = Hashtag(jsonHashtag:Schema.hashtagFrom(element))
            alterElementBeforeAdding(hashtag)
            hashtags.append(hashtag)
        }
        notifCenter.postNotificationName(notificationName, object: self)
    }
    
    func alterElementBeforeAdding(hashtag:Hashtag){
        let user = User.currentUser()
        if user.isFollowing(hashtag){
            hashtag.followedByUser = true
        }
    }

    func didReceiveHashtagAddedUpdate(note: NSNotification){
        var response = HoopsClient.instance().collections["hashtags"] as NSMutableArray
        syncCollection(response)
    }
    
    func didReceiveHashtagChangedUpdate(note: NSNotification){
        /*
        let hashtag = Hashtag(jsonHashtag: Schema.hashtagFrom(note.userInfo!))
        for (i, h) in enumerate(hashtags){
            if h == hashtag{
                hashtags[i].updateFromHashtag(hashtag)
                break
            }
        }*/
    }
    
    func didReceiveHashtagRemovedUpdate(note: NSNotification){
        var response = HoopsClient.instance().collections["hashtags"] as NSMutableArray
        syncCollection(response)
    }
 }