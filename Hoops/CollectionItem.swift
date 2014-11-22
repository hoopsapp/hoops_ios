//
//  CollectionItem.swift
//  Hoops
//
//  Created by Daniel on 08.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class CollectionItem:NSObject{
    let kItemChangedNotification    = "collectionItemChangedNotification"
    let notifCenter                 = NSNotificationCenter.defaultCenter()
    
    var id                  : String    = ""
    var createdAt           : Int64     = 0
    var updatedAt           : Int64     = 0
    var createdOrUpdatedAt  : Int64     = 0
    
    override init(){
        super.init()
    }
}

func == (lhs: CollectionItem, rhs: CollectionItem) -> Bool {
    return lhs.id == rhs.id
}

