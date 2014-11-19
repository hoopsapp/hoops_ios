//
//  Comment.swift
//  Hoops
//
//  Created by Daniel on 10.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class Comment:CollectionItem{
    var owner       : (String, String)  = ("", "")  //0 = ID, 1 = name
    var text        : String            = ""
    var postId      : String            = ""        //0 = ID, 1 = name
    var flagCount   : Int               = 0
    var likeCount   : Int               = 0
    
    
    //Init for comments written by the user
    init(text:String, postId:String){
        super.init()
        self.text = text
        self.postId = postId
    }
    
    //Init for comments from the server
    init(jsonComment : JsonComment){
        super.init()
        self.id         = jsonComment.id
        self.owner      = (jsonComment.user["_id"]!, jsonComment.user["username"]!)
        self.text       = jsonComment.text
        self.postId     = jsonComment.postId
        self.createdAt  = jsonComment.createdAt
        self.flagCount  = jsonComment.flagCount
        self.likeCount  = jsonComment.likeCount
        self.updatedAt  = jsonComment.updatedAt
        self.createdOrUpdatedAt = jsonComment.createdOrUpdatedAt
    }
    
    func like(){
        var paramArr = [id]
        HoopsClient.instance().callMethodName("likeComment", parameters: paramArr, responseCallback: {(response, error) -> Void in
            if(error != nil) {
                //TODO: call error handling function / do error handling
                NSLog("Error on comment like: \(error?.description)")
                return
                
            }
            else{
                self.likeCount++
            }
            NSLog(response.description)
        })
    }
    
    func flag(){
        var paramArr = [id]
        HoopsClient.instance().callMethodName("flagComment", parameters: paramArr, responseCallback: {(response, error) -> Void in
            if(error != nil) {
                //TODO: call error handling function / do error handling
                NSLog("Error on comment flag: \(error?.description)")
                return
                
            }else{
                self.flagCount++
            }
            NSLog(response.description)
        })
    }
    
    //saves changes to the server
    func saveToDb()->Void{
        if(id == ""){
            var paramArr : [String:AnyObject] = [
                "post":postId,
                "text":text
            ]
            
            
            HoopsClient.instance().callMethodName("/comments/insert", parameters: [paramArr], responseCallback: {(response, error) -> Void in
                if(error != nil) {
                    //TODO: call error handling function / do error handling
                    NSLog("Error on Comment insertion: \(error?.description)")
                    return
                    
                }
                NSLog("New Comment added to DB")
            })
        }else{
            //update entry
        }
    }
}