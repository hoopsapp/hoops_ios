//
//  ActivityTime.swift
//  Hoops
//
//  Created by Daniel on 11.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

class ActivityTime{
    //var date : NSDate
    var timestamp: Int64
    
    init(timestamp: Int64){
        self.timestamp = timestamp/1000
    }
    
    func toString()->String{
        var val : Int64
        var unit : String
        var difference  = Int64(NSDate().timeIntervalSince1970) - timestamp //difference in seconds
        if difference > 31556926{ // > 1 year
            val     = difference / 31556926
            unit    = "years"
        }else if difference > 2629743{ //> 1 month
            val     = difference / 2629743
            unit    = "months"
        }else if difference > 604800{ // > 1 week
            val     = difference / 604800
            unit    = "weeks"
        }else if difference > 86400{ // > 1 day
            val     = difference / 86400
            unit    = "days"
        }else if difference > 3600{ // > 1 hour
            val     = difference / 3600
            unit    = "hours"
        }else if difference > 60{ // >1 minute
            val     = difference / 60
            unit    = "minutes"
        }else{ // seconds
            val     = difference
            unit    = "seconds"
        }
        
        if(val == 1){
            unit = unit.substringToIndex(unit.endIndex.predecessor())
        }
        
        //TODO: handle wrong values
        
        return "\(val) \(unit) ago"
    }
}