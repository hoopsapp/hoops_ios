//
//  Post.swift
//  Hoops
//
//  Created by Daniel on 02.07.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class Post:CollectionItem{    
    var owner       : (String, String)  = ("", "")  //0 = ID, 1 = name
    var text        : String            = ""
    var type        : PostType          = PostType.Text
    var hashtag     : (String, String)  = ("", "")  //0 = ID, 1 = name
    var flaggedAt   : Int64             = 0
    var flagCount   : Int               = 0
    var likeCount   : Int               = 0
    var commentCount: Int               = 0
    
    var likedByUser : Bool              = false
    var flaggedByUser: Bool             = false
 
    var location    : (Double, Double)?             //0 => Long, 1 => Lat
    var file        : String?
    
    enum PostType: String {
        case Text  = "text"
        case Image = "image"
        case Video = "video"
    }
    
    override init(){
        super.init()
    }
    
    //Init for new posts written by the user
    init(owner:(String, String), text:String, hashtag:(String, String), type : PostType, location: (Double, Double)?, file : String? ){
        super.init()
        self.owner=owner
        self.text=text
        self.hashtag=hashtag
        self.type=type
        self.location=location
        self.file=file
    }
    
    
    //Init for posts from the server
    init(jsonPost : JsonPost){
        super.init()
        self.id         = jsonPost.id
        self.owner      = (jsonPost.user["_id"]!, jsonPost.user["username"]!)
        self.text       = jsonPost.text
        self.type       = PostType(rawValue: jsonPost.type)!
        self.hashtag    = (jsonPost.hashtagId, "")
        self.flaggedAt  = jsonPost.flaggedAt
        self.createdAt  = jsonPost.createdAt
        self.flagCount  = jsonPost.flagCount
        self.likeCount  = jsonPost.likeCount
        self.updatedAt  = jsonPost.updatedAt
        self.createdOrUpdatedAt = jsonPost.createdOrUpdatedAt
        
        if(jsonPost.file != ""){
            self.file       = jsonPost.file
        }
        
        let user = User.currentUser()
        for flag in jsonPost.flags{
            if flag == user.id{
                flaggedByUser = true
                break
            }
        }
        
        /*
        if(jsonPost.position != LocationHelper.instance().kInvalidLocation){
            self.location   = jsonPost.position
        }*/
    }
    
    func like(){
        var paramArr = [id]
        HoopsClient.instance().callMethodName("likePost", parameters: paramArr, responseCallback: {(response, error) -> Void in
            if(error != nil) {
                //TODO: call error handling function / do error handling
                NSLog("Error on post like: \(error?.description)")
                return
                
            }
            NSLog(response.description)
        })
    }
    
    func flag(){
        var paramArr = [id]
        HoopsClient.instance().callMethodName("flagPost", parameters: paramArr, responseCallback: {(response, error) -> Void in
            if(error != nil) {
                //TODO: call error handling function / do error handling
                NSLog("Error on post flag: \(error?.description)")
                return
                
            }
            NSLog(response.description)
        })
    }

    
    //saves changes to the server
    func saveToDb()->Void{
        if(id == ""){
            
            //check if hashtag id is set, if not use name (server will take care of it)
            var tag = hashtag.0
            if(tag == ""){
                tag = hashtag.1
            }
            
            var paramArr : [String:AnyObject] = [
                "hashtag":tag,
                "text":text,
                "type":type.rawValue
            ]
        
            if let loc = location{
                paramArr["position"] = ["type":"Point", "coordinates": [loc.0, loc.1]]
            }
            
            if let fileKey = file{
                paramArr["file"] = fileKey
            }

            HoopsClient.instance().callMethodName("/posts/insert", parameters: [paramArr], responseCallback: {(response, error) -> Void in
                if(error != nil) {
                    //TODO: call error handling function / do error handling
                    NSLog("Error on post insertion: \(error?.description)")
                    return
                }
                NSLog("New Post added to DB")
            })
        }else{
            //update entry
        }
    }
    
    func updateFromPost(updPost:Post){
        flaggedAt = updPost.flaggedAt
        flagCount = updPost.flagCount
        likeCount = updPost.likeCount
        commentCount = updPost.commentCount
        flaggedByUser = updPost.flaggedByUser
        likedByUser = updPost.likedByUser
        NSNotificationCenter.defaultCenter().postNotificationName(kItemChangedNotification, object: self)
    }
}

