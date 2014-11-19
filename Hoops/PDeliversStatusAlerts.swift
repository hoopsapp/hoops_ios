//
//  PDeliversStatusAlerts.swift
//  Hoops
//
//  Created by Daniel on 17.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation
import UIKit

protocol PDeliversStatusAlerts{
    func displaySimpleAlert(#title:String, message:String)
    func displayModalDialog(#title:String, message:String, yesHandler:((UIAlertAction!) -> Void)?, noHandler: ((UIAlertAction!) -> Void)?)
    
}