//
//  HotnessSorter.swift
//  Hoops
//
//  Created by Daniel on 20.10.14.
//  Copyright (c) 2014 hoops. All rights reserved.
//

import Foundation

class HotnessSorter<T:Hashtag>:FeedFilter<T>{
    override func statisfiesRequirements(element:T)->Bool{
        return true
    }
    
    override func compare(element1:T, element2:T)->Bool{
        return element1.hotness < element2.hotness
    }
}