//
//  TimeSorter.swift
//  Hoops
//
//  Created by Daniel on 23.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class TimeSorter<T:CollectionItem>:FeedFilter<T>{
    var reverse = false
    
    override init() {
        super.init()
    }
    
    init (reverse:Bool){
        super.init()
        self.reverse = reverse
    }
    
    override func statisfiesRequirements(element:T)->Bool{
        return true
    }
    
    override func compare(element1:T, element2:T)->Bool{
        let result = element1.createdOrUpdatedAt > element2.createdOrUpdatedAt
        if reverse{
            return !result
        }
        return result
    }
}