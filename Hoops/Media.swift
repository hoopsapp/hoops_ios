//
//  Media.swift
//  Hoops
//
//  Created by Daniel on 26.09.14.
//  Copyright (c) 2014 hoops. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
let kMaxImageWidth  : CGFloat = 500.0
let kMaxImageHeight : CGFloat = 500.0

class Media:NSObject{
    
    //notifications sent by this class
    let kPolicyReceivedNotification  = "s3policy_received"
    let kFileUploadedNotification: String
    let kFileDownloadedNotification: String

    //general attributes
    var notifCenter : NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    //specific attributes
    var file        : NSData?
    var filename    : String?
    var type        : Post.PostType
    
    var s3UploadPolicy      : JsonS3UploadPolicy?
    var s3DownloadPolicy    : JsonS3DownloadPolicy?
    
    
    class func scaleImage(image:UIImage)->UIImage{
        let width   = image.size.width
        let height  = image.size.height
        var factor  : CGFloat = 0.0
        
        if(width > kMaxImageWidth || height > kMaxImageHeight){
            if(width > height){ //width = long side
                factor = kMaxImageWidth / width
            }else{              //height = long side
                factor = kMaxImageHeight / height
            }
        }
        
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(factor, factor))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    //init for files that should be uploaded
    init(file : NSData, type: Post.PostType){
        kFileUploadedNotification   = "\(NSUUID().UUIDString)_file_uploaded"
        kFileDownloadedNotification = "\(NSUUID().UUIDString)_file_downloaded"
        self.file = file
        self.type = type
    }
    
    //init for files from the server that should be downloaded
    init(filename: String, type: Post.PostType){
        kFileUploadedNotification   = "\(NSUUID().UUIDString)_file_uploaded"
        kFileDownloadedNotification = "\(NSUUID().UUIDString)_file_downloaded"
        self.filename   = filename
        self.type       = type
    }
    
    
    func typeToMimeType(type: Post.PostType)->String{
        switch(type){
        case Post.PostType.Image: return "image/jpeg"
        case Post.PostType.Video: return "video/mp4"
        default: return "image/jpeg"
        }
    }
    
    func typeToFileExt(type: Post.PostType)->String{
        switch(type){
        case Post.PostType.Image: return "jpeg"
        case Post.PostType.Video: return "mp4"
        default: return "jpeg"
        }
    }

    //*****************
    //Download functions
    //*****************
    
    func download(){
        getS3DownloadPolicy()
    }
    
    func getS3DownloadPolicy(){
        var paramArr    = [filename!]
        HoopsClient.instance().callMethodName("s3Download", parameters: paramArr, responseCallback: {(response, error) -> Void in
            if(error != nil) {
                NSLog("Error on download from s3: \(error?.description)")
                return
            }
            let dict = response as [String:AnyObject]
            
            if let receivedPolicy: AnyObject = dict["result"]{
                self.s3DownloadPolicy   = Schema.s3DownloadPolicyFrom(receivedPolicy)
                self.downloadFileFromUrl(self.s3DownloadPolicy!.url)

            }
            
        })
    }
    

    
    
    func downloadFileFromUrl(url:String){
        var fileName: String?
        var localURL : NSURL?
        
        Alamofire.download(.GET, url,
            {(temporaryURL, response) in
                if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                    fileName = response.suggestedFilename
                    localURL = directoryURL.URLByAppendingPathComponent(fileName!)
                    return localURL!
                }
                return temporaryURL
            }
        )
        .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
            //TODO: show progress
        }
        .response { (request, response, _, error) in
            var err: NSError?
            NSLog(localURL!.description)

            self.file = NSData(contentsOfURL: localURL! ,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
            self.notifCenter.postNotificationName(self.kFileDownloadedNotification, object: self)
        }
    }

    //*****************
    //Upload functions
    //*****************
    
    func upload(){
        getS3UploadPolicy()
    }
    
    
    func getS3UploadPolicy(){
        let username    = User.currentUser().name
        let fileExt     = typeToFileExt(type)
        var paramArr    = ["\(username)_\(type.rawValue).\(fileExt)"]
        HoopsClient.instance().callMethodName("s3Upload", parameters: paramArr, responseCallback: {(response, error) -> Void in
            if(error != nil) {
                NSLog("Error on upload to s3: \(error?.description)")
                return
            }
            NSLog(response.description)
            let dict = response as [String:AnyObject]
            if let receivedPolicy: AnyObject = dict["result"]{
                self.s3UploadPolicy   = Schema.s3UploadPolicyFrom(receivedPolicy)
                self.filename   = self.s3UploadPolicy!.key
                self.uploadFileToUrl(self.s3UploadPolicy!.url)
            }

        })
    }
    
    func uploadFileToUrl(url:String){
        var response    : AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var request     : NSURLRequest  = createRequest(url, data: file!)
        var HTTPError   : NSError?      = nil
        var JSONError   : NSError?      = nil
        
        //TODO: Show activity notification
        
        var dataVal: NSData? =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &HTTPError)
        
        if ((dataVal != nil) && (HTTPError == nil)) {
            NSLog("S3 image upload successful")
            self.notifCenter.postNotificationName(self.kFileUploadedNotification, object: self)
        } else if (HTTPError != nil) {
            NSLog("S3 upload request failed:\(HTTPError!.description)")
        } else {
            NSLog("S3 request returned no data returned")
        }
   }
    
   func createRequest (url:String, data: NSData) -> NSURLRequest {
        let param = [
            "AWSAccessKeyId"    : s3UploadPolicy!.s3Key,
            "policy"            : s3UploadPolicy!.s3PolicyBase64,
            "signature"         : s3UploadPolicy!.s3Signature,
            "key"               : s3UploadPolicy!.key,
            "Content-Type"      : s3UploadPolicy!.mimeType,
            "acl"               : "private"
        ]
        
        let boundary        = "Boundary-\(NSUUID().UUIDString)"
        let request         = NSMutableURLRequest(URL: NSURL(string:url)!)
        request.HTTPMethod  = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = createBodyWithParameters(param, data: data, boundary: boundary)
        
        return request
    }
    
    func createBodyWithParameters(parameters: [String: String], data: NSData, boundary: String) -> NSData {
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        let mimetype    = typeToMimeType(self.type)
                
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(data)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }
}


extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}