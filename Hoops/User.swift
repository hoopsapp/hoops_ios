//
//  User.swift
//  Hoops
//
//  Created by Daniel on 06.07.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation
let _currentUser : User = User()

class User:CollectionItem{
    var name        : String    = ""
    var followedHashtags: [JsonFollowes] = [JsonFollowes]()
    var likes :[JsonLike] = [JsonLike]()
    
    class func currentUser()->User{
        //Get user of this device
        if(_currentUser.id == ""){
            //subscribe to User changes
            HoopsClient.instance().addSubscription("users")
            NSNotificationCenter.defaultCenter().addObserver(_currentUser, selector: "didReceiveAddedUpdate:", name: "users_added", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(_currentUser, selector: "didReceiveChangedUpdate:", name: "users_changed", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(_currentUser, selector: "didReceiveRemovedUpdate:", name: "users_removed", object: nil)
            
            //subscribe to followes
            NSNotificationCenter.defaultCenter().addObserver(_currentUser, selector: "didReceiveFollowAddedUpdate:", name: "followes_added", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(_currentUser, selector: "didReceiveFollowRemovedUpdate:", name: "followes_removed", object: nil)
            
            //subscribe to likes
            NSNotificationCenter.defaultCenter().addObserver(_currentUser, selector: "didReceiveLikeAddedUpdate:", name: "likes_added", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(_currentUser, selector: "didReceiveLikeRemovedUpdate:", name: "likes_removed", object: nil)
        }
        return _currentUser
    }
    
    override init(){
        super.init()
    }
    
    init(id:String, name:String){
        super.init()
        self.id = id
        self.name = name
    }
    
    func isFollowing(hashtag:Hashtag)->Bool{
        for follow in followedHashtags{
            if follow.hashtag == hashtag.id && follow.user == id{
                return true
            }
        }
        return false
    }
    
    func hasLiked(post:Post)->Bool{
        for like in likes{
            if like.post == post.id && like.user == id{
                return true
            }
        }
        return false
    }
    
    func hasLiked(comment:Comment)->Bool{
        return false
    }
    
    func hasFlagged(post:Post)-> Bool{
        return false
    }
    
    func hasFlagged(comment:Comment)-> Bool{
        return false
    }

    
    //NOTIFICATIONS    
    func didReceiveAddedUpdate(note: NSNotification!){
        var response = HoopsClient.instance().collections["users"] as NSMutableArray
        let jsonUser = Schema.userFrom(response[0])
        
        id      = jsonUser.id
        name    = jsonUser.name
    }
    
    func didReceiveRemovedUpdate(note:NSNotification!){
        NSLog("User removed")
    }
    
    func didReceiveChangedUpdate(note:NSNotification!){
        NSLog("User updated")
    }
    
    func didReceiveFollowAddedUpdate(note: NSNotification!){
        let follow   = Schema.followesFrom(note.userInfo!)
        followedHashtags.append(follow)
    }
    
    func didReceiveFollowRemovedUpdate(note:NSNotification!){
        let follow   = Schema.followesFrom(note.userInfo!)
        for (key, value) in enumerate(followedHashtags){
            if value.hashtag == follow.hashtag{
                followedHashtags.removeAtIndex(key)
                return
            }
        }
    }
    
    func didReceiveLikeAddedUpdate(note: NSNotification!){
        let like = Schema.likeFrom(note.userInfo!)
        let dict = ["likedByUser":true]
        let notif = (like.post == "") ? "\(like.comment)_comment" : "\(like.post)_post"
        likes.append(like)
        notifCenter.postNotificationName(notif, object: dict)
    }
    
    func didReceiveLikeRemovedUpdate(note:NSNotification!){
        let like = Schema.likeFrom(note.userInfo!)
        for (key, value) in enumerate(likes){
            if(value.id == like.id){
                likes.removeAtIndex(key)
                return
            }
        }
    }
}