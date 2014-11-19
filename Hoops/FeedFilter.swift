//
//  BaseFilter.swift
//  Hoops
//
//  Created by Daniel on 23.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class FeedFilter<T:CollectionItem>{
    func filter(elements:[T])->[T]{
        var result = elements
        result.filter(statisfiesRequirements)
        result.sort(compare)
        return result
    }
    
    func statisfiesRequirements(element:T)->Bool{
        return true
    }
    
    func compare(element1:T, element2:T)->Bool{
        return true
    }
}