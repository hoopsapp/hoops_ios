//
//  Schema.swift
//  Hoops
//
//  Created by Daniel on 21.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation

struct JsonPost{
    var id                  : String            = ""
    var user                : [String:String]   = [String:String]()
    var text                : String            = ""
    var hashtagId           : String            = ""
    var type                : String            = Post.PostType.Text.rawValue
    var flaggedAt           : Int64             = 0
    var updatedAt           : Int64             = 0
    var createdAt           : Int64             = 0
    var createdOrUpdatedAt  : Int64             = 0
    var flags               : [String]          = [String]()
    var flagCount           : Int               = 0
    var likeCount           : Int               = 0
    var position            : (Double, Double)  = LocationHelper.instance().kInvalidLocation
    var file                : String            = ""
}

struct JsonComment{
    var id                  : String            = ""
    var user                : [String:String]   = [String:String]()
    var text                : String            = ""
    var postId              : String            = ""
    var updatedAt           : Int64               = 0
    var createdAt           : Int64             = 0
    var createdOrUpdatedAt  : Int64               = 0
    var flagCount           : Int               = 0
    var likeCount           : Int               = 0
}

struct JsonHashtag{
    var id                  : String            = ""
    var title               : String            = ""
    var slug                : String            = ""
    var user                : [String:String]   = [String:String]()
    var followers           : Int               = 0
    var hotness             : Int               = 0
    var posts               : Int               = 0
    var createdAt           : Int64             = 0
    var updatedAt           : Int64               = 0
    var createdOrUpdatedAt  : Int64               = 0
}

struct JsonUser{
    var id                  : String            = ""
    var name                : String            = ""
}

struct JsonCount{
    var id                  : String            = ""
    var count               : Int               = 0
}

struct JsonFollowes{
    var id                  : String            = ""
    var user                : String            = ""
    var hashtag             : String            = ""
}

struct JsonLike{
    var id                  : String            = ""
    var user                : String            = ""
    var post                : String            = ""
    var comment             : String            = ""
}

struct JsonS3UploadPolicy{
    var bucket              : String            = ""
    var key                 : String            = ""
    var mimeType            : String            = ""
    var regionDomain        : String            = ""
    var s3Key               : String            = ""
    var s3PolicyBase64      : String            = ""
    var s3Signature         : String            = ""
    var url                 : String            = ""
}

struct JsonS3DownloadPolicy{
    var url                 : String            = ""
    var expires             : Int64             = 0
}


class Schema{
    class func postFrom(data:AnyObject)->JsonPost{
        var dict  : [String:AnyObject]
        var jsonPost = JsonPost()
        var dateCre     : [String:AnyObject]?
        var dateUpd     : [String:AnyObject]?
        var dateCreUpd  : [String:AnyObject]?
        var dateFlagged : [String:AnyObject]?
     
        dict = data as [String:AnyObject]
        //create post object
        for (key, val) in dict{
            switch key{
            case "_id"                  : jsonPost.id                   = val as String
            case "text"                 : jsonPost.text                 = val as String
            case "hashtag"              : jsonPost.hashtagId            = val as String
            case "user"                 : jsonPost.user                 = val as [String:String]
            case "type"                 : jsonPost.type                 = val as String
            case "file"                 : jsonPost.file                 = val as String
            case "flags"                : jsonPost.flags                = val as [String]
            case "flagCount"            : jsonPost.flagCount            = val as Int
            case "likeCount"            : jsonPost.likeCount            = val as Int
            case "flaggedAt"          : dateFlagged                     = (val as [String:AnyObject])
            case "createdAt"            : dateCre                       = (val as [String:AnyObject])
            case "updatedAt"            : dateUpd                       = (val as [String:AnyObject])
            case "createdOrUpdatedAt"   : dateCreUpd                    = (val as [String:AnyObject])
            case "position"             :
                let casted = val as [String:AnyObject]
                let coords = casted["coordinates"]! as [Double]
                jsonPost.position = (coords[0], coords[1])
            default                     : NSLog("Unexpected key '\(key)' in received post")
            }
        }
        
        if let date = dateFlagged{
            let number = date["$date"]! as NSNumber
            jsonPost.flaggedAt = number.longLongValue
        }
        
        if let date = dateCre{
            let number = date["$date"]! as NSNumber
            jsonPost.createdAt = number.longLongValue
        }
        
        if let date = dateUpd{
            let number = date["$date"]! as NSNumber
            jsonPost.updatedAt = number.longLongValue
        }
        
        if let date = dateCreUpd{
            let number = date["$date"]! as NSNumber
            jsonPost.createdOrUpdatedAt = number.longLongValue
        }
        
        return jsonPost
    }
    
    class func commentFrom(data:AnyObject)->JsonComment{
        var dict  : [String:AnyObject]
        var jsonComment = JsonComment()
        var dateCre     : [String:AnyObject]?
        var dateUpd     : [String:AnyObject]?
        var dateCreUpd  : [String:AnyObject]?
        
        dict = data as [String:AnyObject]
        
        //create comment object
        for (key, val) in dict{
            switch key{
            case "_id"                  : jsonComment.id                = val as String
            case "text"                 : jsonComment.text              = val as String
            case "post"                 : jsonComment.postId            = val as String
            case "user"                 : jsonComment.user              = val as [String:String]
            case "flagCount"            : jsonComment.flagCount         = val as Int
            case "likeCount"            : jsonComment.likeCount         = val as Int
            case "createdAt"            : dateCre                       = (val as [String:AnyObject])
            case "updatedAt"            : dateUpd                       = (val as [String:AnyObject])
            case "createdOrUpdatedAt"   : dateCreUpd                    = (val as [String:AnyObject])
            default                     : NSLog("Unexpected key '\(key)' in received comment")
            }
        }
        
        if let date = dateCre{
            let number = date["$date"]! as NSNumber
            jsonComment.createdAt = number.longLongValue
        }
        
        if let date = dateUpd{
            let number = date["$date"]! as NSNumber
            jsonComment.updatedAt = number.longLongValue
        }
        
        if let date = dateCreUpd{
            let number = date["$date"]! as NSNumber
            jsonComment.createdOrUpdatedAt = number.longLongValue
        }
        
        return jsonComment
    }
    
    
    class func hashtagFrom(data:AnyObject)->JsonHashtag{
        
        var dict  : [String:AnyObject]
        var jsonHashtag = JsonHashtag()
        var dateCre     : [String:AnyObject]?
        var dateUpd     : [String:AnyObject]?
        var dateCreUpd  : [String:AnyObject]?
    
        dict = data as [String:AnyObject]
        
        //create Hashtag object
        for (key, val) in dict{
            switch key{
            case "_id"                  : jsonHashtag.id                   = val as String
            case "title"                : jsonHashtag.title                = val as String
            case "slug"                 : jsonHashtag.slug                 = val as String
            case "followers"            : jsonHashtag.followers            = val as Int
            case "hotness"              : jsonHashtag.hotness              = val as Int
            case "posts"                : jsonHashtag.posts                = val as Int
            case "createdAt"            : dateCre                          = (val as [String:AnyObject])
            case "updatedAt"            : dateUpd                          = (val as [String:AnyObject])
            case "createdOrUpdatedAt"   : dateCreUpd                       = (val as [String:AnyObject])
            case "user"                 : jsonHashtag.user                 = val as [String:String]
            default                     : NSLog("Unexpected key '\(key)' in received Hashtag")
            }
        }
        
        if let date = dateCre{
            let number = date["$date"]! as NSNumber
            jsonHashtag.createdAt = number.longLongValue
        }
        
        if let date = dateUpd{
            let number = date["$date"]! as NSNumber
            jsonHashtag.updatedAt = number.longLongValue
        }
        
        if let date = dateCreUpd{
            let number = date["$date"]! as NSNumber
            jsonHashtag.createdOrUpdatedAt = number.longLongValue
        }
        
        return jsonHashtag
    }
    
    class func commentCountFrom(data:AnyObject, postId:String)->JsonCount{
        var array :[[String:AnyObject]]
        var jsonCount   = JsonCount()
        var dictId = "comments-\(postId)"
      
        array = data as [[String:AnyObject]]
        
        //find dict
        for dict in array{
            if(dict["_id"]! as String == dictId){
                for(dictKey, dictVal) in dict{
                    switch dictKey{
                    case "_id"      : jsonCount.id      = dictVal as String
                    case "count"    : jsonCount.count   = dictVal as Int
                    default         : NSLog("Unexpected key '\(dictKey)' in received count")
                    }
                }
            }
        }

        return jsonCount
    }
    
    class func followesFrom(data:AnyObject)->JsonFollowes{
        var dict :[String:AnyObject]
        dict = data as [String:AnyObject]
        
        //find dict
        var jsonFollowes   = JsonFollowes()
        for (dictKey, dictVal) in dict{
            switch dictKey{
                case "_id"      : jsonFollowes.id      = dictVal as String
                case "user"     : jsonFollowes.user    = dictVal as String
                case "hashtag"  : jsonFollowes.hashtag = dictVal as String
                default         : NSLog("Unexpected key '\(dictKey)' in received follow")
            }
        }
        
        return jsonFollowes
    }

    class func likeFrom(data:AnyObject)->JsonLike{
        var dict :[String:AnyObject]
        dict = data as [String:AnyObject]
        
        //find dict
        var jsonLike   = JsonLike()
        for (dictKey, dictVal) in dict{
            switch dictKey{
            case "_id"      : jsonLike.id      = dictVal as String
            case "user"     : jsonLike.user    = dictVal as String
            case "post"     : jsonLike.post    = dictVal as String
            case "comment"  : jsonLike.comment = dictVal as String
            default         : NSLog("Unexpected key '\(dictKey)' in received follow")
            }
        }
        
        return jsonLike
    }
    
    class func userFrom(data:AnyObject)->JsonUser{
        var dict :[String:AnyObject]
        var jsonUser = JsonUser()
        var profile  = [String:AnyObject]()
        
        dict = data as [String:AnyObject]
        
        for (key, val) in dict{
            switch key{
            case "_id"      : jsonUser.id        = val as String
            case "username" : jsonUser.name      = val as String
            case "profile"  : profile   = val as [String: AnyObject]
            default         : NSLog("Unexpected key '\(key)' in received user")
            }
        }
        return jsonUser
    }
    
    
    class func s3UploadPolicyFrom(data:AnyObject)->JsonS3UploadPolicy{
        var dict :[String:String]
        var jsonS3Policy = JsonS3UploadPolicy()
        
        dict = data as [String:String]
        
        for (key, val) in dict{
            switch key{
            case "bucket"           : jsonS3Policy.bucket           = val as String
            case "key"              : jsonS3Policy.key              = val as String
            case "mimeType"         : jsonS3Policy.mimeType         = val as String
            case "reqionDomain"     : jsonS3Policy.regionDomain     = val as String //TODO: schreibfehler im Backendd
            case "s3Key"            : jsonS3Policy.s3Key            = val as String
            case "s3PolicyBase64"   : jsonS3Policy.s3PolicyBase64   = val as String
            case "s3Signature"      : jsonS3Policy.s3Signature      = val as String
            case "url"              : jsonS3Policy.url              = val as String
            default         : NSLog("Unexpected key '\(key)' in received s3policy")
            }
        }
        return jsonS3Policy
    }
    
    class func s3DownloadPolicyFrom(data:AnyObject)->JsonS3DownloadPolicy{
        var dict :[String:AnyObject]
        var jsonS3Policy = JsonS3DownloadPolicy()
        var expires : NSNumber?
        
        dict = data as [String:AnyObject]
        
        for (key, val) in dict{
            switch key{
            case "expires"          : expires          = val as NSNumber
            case "url"              : jsonS3Policy.url = val as String
            default         : NSLog("Unexpected key '\(key)' in received s3policy")
            }
        }
        
        if let exp = expires{
            jsonS3Policy.expires = exp.longLongValue
        }
        
        return jsonS3Policy
    }
}