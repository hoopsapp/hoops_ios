//
//  Hashtag.swift
//  Hashtag
//
//  Created by Daniel on 06.07.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class Hashtag:CollectionItem, Equatable{
    var title           : String    = ""
    var hotness         : Int       = 0
    var posts           : Int       = 0
    
    var followedByUser  : Bool      = false
    
    

    
    class func search(query:String)->[Hashtag]{
        var result      = [Hashtag]()
        var paramArr    = [query]
        var value       = 5
        
        HoopsClient.instance().callMethodName("searchHashtags", parameters: paramArr, responseCallback: {(response, error) -> Void in
            if(error != nil) {
                //TODO: call error handling function / do error handling
                NSLog("Error on hashtagSearch like: \(error?.description)")
                return
            }
            
            //interpret response
            let dict = response as [String:AnyObject]
            if let tags: AnyObject = dict["result"]{
                let tagsDict = tags as [AnyObject]
                for tag in tagsDict{
                    let jsonTag = Schema.hashtagFrom(tag)
                    result.append(Hashtag(jsonHashtag:jsonTag))
                }
            }
            value = 10
        })
        
        return result
    }
    
    override init(){
        super.init()
    }
    
    //Init for hashtags created by user
    init(title:String){
        super.init()
        self.title = title
    }
    
    //Init for followed hashtags
    init(id:String, title: String){
        super.init()
        self.id = id
        self.title = title
    }
 
    init(jsonHashtag:JsonHashtag){
        super.init()
        self.id        = jsonHashtag.id
        self.title     = jsonHashtag.title
        self.hotness   = jsonHashtag.hotness
        self.posts     = jsonHashtag.posts
        self.createdAt = jsonHashtag.createdAt
        self.updatedAt = jsonHashtag.updatedAt
        self.createdOrUpdatedAt = jsonHashtag.createdOrUpdatedAt
    }

    func follow(){
        var paramArr = [id, false]
        HoopsClient.instance().callMethodName("follow", parameters: paramArr, responseCallback: {(response, error) -> Void in
            if(error != nil) {
                //TODO: call error handling function / do error handling
                NSLog("Error on hashtag follow: \(error?.description)")
                return
                
            }
            NSLog(response.description)
        })

    }
    
    //saves changes to the server
    func saveToDb()->Void{
        if(id == ""){
            var paramArr = [[
                "title":title
                ]]            
            id = HoopsClient.instance().callMethodName("/hashtags/insert", parameters: paramArr, responseCallback: {(response, error) -> Void in
                if(error != nil) {
                    //TODO: call error handling function / do error handling
                    NSLog("Error on hashtag insertion: \(error?.description)")
                    return
                    
                }
                NSLog(response.description)
                NSLog("New Hashtag added to DB")
            })
        }else{
            //update entry
        }
    }
    
    func updateFromHashtag(updHashtag:Hashtag){
        followedByUser = updHashtag.followedByUser
        NSNotificationCenter.defaultCenter().postNotificationName(kItemChangedNotification, object: self)
    }
}

func == (lhs: Hashtag, rhs: Hashtag) -> Bool {
    return lhs.id == rhs.id || lhs.title == rhs.title
}