//
//  Feed.swift
//  Hoops
//
//  Created by Daniel on 03.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class Feed:NSObject{
    let kLimitIncrement : Int   = 20
    
    let client      : MeteorClient
    let notifCenter : NSNotificationCenter = NSNotificationCenter.defaultCenter()

    var limit       : Int
    var active      : Bool = false
    
    init(client:MeteorClient){
        self.client = client
        limit = kLimitIncrement
        super.init()
    }
   
    func subscribe(){
        if(!active){
            active = true
        }
    }
    
    func unsubscribe(){
        if(active){
            active = false
        }
    }
    
    func increaseLimit(){
        assert(false, "implement increase limit")
    }
    
}