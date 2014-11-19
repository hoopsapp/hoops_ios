//
//  FeedFilterChain.swift
//  Hoops
//
//  Created by Daniel on 23.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class FeedFilterChain<T:CollectionItem>:FeedFilter<T>{
    var filters = [FeedFilter<T>]()
        
    override func statisfiesRequirements(element:T)->Bool{
        if filters.count == 0 {return true}
        
        for filter in filters{
            if(!filter.statisfiesRequirements(element)){
                return false
            }
        }
        return true
    }
    
    override func compare(element1:T, element2:T)->Bool{
        if filters.count == 0 {return true}
        
        var count = 0
        for filter in filters{
            ++count
            if filter.compare(element1, element2:element2) == filter.compare(element2, element2:element1) && count != filters.count{
                //if changing arguments yields same result (== no specific order) go one filter deeper
                continue
            }else{
                return filter.compare(element1, element2: element2)
            }
        }
        return true
    }
    
    func addFilter(filter:FeedFilter<T>){
        filters.append(filter)
    }
}