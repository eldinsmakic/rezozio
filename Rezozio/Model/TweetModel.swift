//
//  TweetModel.swift
//  Rezozio
//
//  Created by eldin smakic on 30/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//

import Foundation
import UIKit

class TweetModel
{
    
        var username: String?
        var userIdent: String?
        var userUID : String?
        var userImageLink : String?
        var image: UIImage?
        var tweet: String?
        
    init(username : String , userUID: String,  userIdent: String , tweet: String, img : UIImage, userImageLink : String )
        {
            self.username = username
            self.image = img
            self.userIdent = userIdent
            self.userUID = userUID
            self.userImageLink = userImageLink
            self.tweet = tweet
        }
    
    
        public func setImage(image :UIImage)
        {
            self.image = image
        }

}
