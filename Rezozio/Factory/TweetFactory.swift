//
//  TweetFactory.swift
//  Rezozio
//
//  Created by eldin smakic on 08/01/2020.
//  Copyright © 2020 eldin smakic. All rights reserved.
//
// All utilities to createe TweetModel to bind data from firebase

import Foundation
import FirebaseFirestore
import FirebaseAuth


class TweetFactory
{
    
    public static let factory = TweetFactory()
    
    public func createTweetFromData(data : [String : Any]) -> TweetModel
    {
        let user = data["user"] as! [String : Any]
        return TweetModel(username: user["name"] as! String, userUID: user["id"] as! String, userIdent: user["screen_name"] as! String, tweet: data["text"] as! String, img: #imageLiteral(resourceName: "ImgProfile1"), userImageLink: user["image"] as! String)
    }
    
    public func createDataForNewTweet(text : String , user : UserModel) -> [String : Any]
    {
        return [
            "create_at" : Timestamp(date: Date()),
            "text" : text,
            "user" :
                ["id" : Auth.auth().currentUser!.uid ,
                "name" : user.getName(),
                "screen_name" : user.getScreenName(),
                "image" :  user.getImageLink()],
            "hashtags" : [],
            "user_mentions" : []
        ]
    }
}
