//
//  HoopsClient.swift
//  Hoops
//
//  Created by Daniel on 04.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

let _client = HoopsClient()
let kConnectionLostNotification = "connection_lost"

class HoopsClient : MeteorClient{
    var isConnected : Bool = true
    
    class func instance() -> HoopsClient{
        return _client
    }
    
    override init(){
        super.init(DDPVersion:"pre2")
        //ddp = ObjectiveDDP(URLString: "ws://hoops.social/websocket", delegate: self)
        ddp = ObjectiveDDP(URLString: "ws://54.76.147.204:3000/websocket", delegate: self)
        //ddp = ObjectiveDDP(URLString: "ws://localhost:3000/websocket", delegate: self)
        //ddp = ObjectiveDDP(URLString: "ws://192.168.178.20:3000/websocket", delegate: self)
        
        ddp.connectWebSocket()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "connectedToServer:",
            name: MeteorClientConnectionReadyNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "disconnectedFromServer:",
            name: MeteorClientDidDisconnectNotification,
            object: nil)
    }
    
    
    override func addSubscription(subscriptionName: String!, withParameters parameters: [AnyObject]!) {
        super.addSubscription(subscriptionName, withParameters: parameters)
        
        NSLog("Subscribed to \(subscriptionName)")
    }

    override func addSubscription(subscriptionName: String!) {
        super.addSubscription(subscriptionName)
    }
    
    
    func connectedToServer(notification : NSNotification){
        NSLog("Connected to Meteor Server")
        
        //Auth user
        Authenticator.auth(self, errorHandling: {(response, error) -> Void in
            if((error) != nil) {
                //TODO: call error handling function / do error handling
                NSLog("Error on Authentication: \(error?.description)")
                return

            }
            //TODO: call error handling function / do error handling
            NSLog("Authentication Successful")
            if(!self.isConnected){
                self.isConnected = true
            }
        })
        
        
    }
    
    func disconnectedFromServer(notification: NSNotification){
        NSLog("Disconnected from Meteor Server")
        
        if(isConnected){
            isConnected = false
            NSNotificationCenter.defaultCenter().postNotificationName(kConnectionLostNotification, object: nil)
        }
    }
}