//
//  Authenticator.swift
//  Hoops
//
//  Created by Daniel on 28.07.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

//TODO: Increase security, current functions = bullshit
class Authenticator{
    
    class func auth(client:MeteorClient, errorHandling:MeteorClientMethodCallback)->Bool{
        //TODO:Debug
        //var appDomain = NSBundle.mainBundle().bundleIdentifier
        //NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        //get saved info
        var username:String? = NSUserDefaults.standardUserDefaults().stringForKey("username")
        var password:String? = NSUserDefaults.standardUserDefaults().stringForKey("password")

        if(username == nil || password == nil){
            createNewUser(client);
        }
        else{
            client.logonWithUsername(username, password: password, responseCallback: errorHandling)
        }
        return true
    }
    
    class func createNewUser(client:MeteorClient){
        var userId   = Authenticator.createUserId()
        var username = Authenticator.createUserName()
        var password = Authenticator.createPassword()
        var fullname = username
      
        client.signupWithUsername(username, password: password, fullname: fullname, responseCallback:{(response, error) -> Void in
            if((error) != nil) {
                //TODO: call error handling function / do error handling
                NSLog("Error on signup: \(error?.description)")
                return
            }
            //TODO: call error handling function / do error handling
            NSLog("Signup Successful")
        })

        NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
        NSUserDefaults.standardUserDefaults().setValue(password, forKey: "password")
        
    }
    
    class func createUserId()->String{
        return NSUUID().UUIDString
    }
    
    class func createUserName()->String{
        //create random username
        var username = "User"
        var rand:UInt32
        var i = 0
        do{
            rand = arc4random_uniform(24)
            i++
            username += String(rand)
        }while (i < 4)
        return username
    }
    
    class func createPassword()->String{
        //create password from UUID
        return Authenticator.createUserId()
    }
}