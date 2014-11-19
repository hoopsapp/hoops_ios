//
//  AutoCompletion.swift
//  Hoops
//
//  Created by Daniel on 21.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class AutoCompletion{
    let kAutoCompletionUpdatedNotification = "autocompletion_updated"
    let notifCenter = NSNotificationCenter.defaultCenter()
    
    var result = [Hashtag]()
    
    func search(query:String){
        var paramArr    = [query]
               
        HoopsClient.instance().callMethodName("searchHashtags", parameters: paramArr, responseCallback: {(response, error) -> Void in
            if(error != nil) {
                //TODO: call error handling function / do error handling
                NSLog("Error on hashtagSearch like: \(error?.description)")
                return
            }
            
            //interpret response
            self.result.removeAll(keepCapacity: true)
            let dict = response as [String:AnyObject]
            if let tags: AnyObject = dict["result"]{
                let tagsDict = tags as [AnyObject]
                for tag in tagsDict{
                    let jsonTag = Schema.hashtagFrom(tag)
                    self.result.append(Hashtag(jsonHashtag:jsonTag))
                }
            }
            self.notifCenter.postNotificationName(self.kAutoCompletionUpdatedNotification, object: self.result)
        })
    }
    
    

    
}