//
//  NearbyHashtagFeed.swift
//  Hoops
//
//  Created by Daniel on 03.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation
import CoreLocation

class NearbyHashtagFeed:HashtagFeed{
    let locHelper = LocationHelper.instance()
   
    override init(client: MeteorClient) {
        super.init(client: client)
        notificationName = "nearby_hashtag_feed_changed"
        feedFilter = LocationSorter<Hashtag>()
    }
    
    override func subscribe(){
        if(!active){
            //check location authorization
            if(locHelper.isAuthorized){//is authorized?
                if let location = locHelper.location{ //already received location?
                    client.addSubscription(
                        "nearestHashtags",
                        withParameters: [
                            ["type":"Point", "coordinates": [location.0, location.1]],
                            "",
                            limit
                        ]
                    )
                }else{ //authorized but didn't receive location
                    //TODO: if authorized but no location => no signal?!!? show message and wait
                    notifCenter.addObserver(self, selector: "didReceiveFirstLocationNotification:", name: LocationHelper.instance().kFirstLocationNotification, object: nil)
                }
            }else{ //is not authorized
                notifCenter.postNotificationName("location_permission_needed", object: self)
                notifCenter.addObserver(self, selector: "didReceiveFirstLocationNotification:", name: LocationHelper.instance().kFirstLocationNotification, object: nil)
            }
        }
        super.subscribe()
    }
    
    override func unsubscribe(){
        if(active){
            client.removeSubscription("nearestHashtags")
        }
        super.unsubscribe()
    }
    
    func didReceiveFirstLocationNotification(note: NSNotification){
        if let location = locHelper.location{
            client.addSubscription(
                "nearestHashtags",
                withParameters: [
                    ["type":"Point", "coordinates": [location.0, location.1]],
                    "",
                    limit
                ]
            )
        }
    }
}