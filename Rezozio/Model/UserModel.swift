//
//  UserModel.swift
//  Rezozio
//
//  Created by eldin smakic on 28/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//
//  class UserModel is a model for UserCell
//

import Foundation
import UIKit

class UserModel
{
    
    private var id: String?
    private var name: String?
    private var screenName: String?
    private var mail: String?
    private var image: UIImage?
    private var description: String?
    private var followersCount : Int
    private var friendsCount : Int
    private var isFollowByUser : Bool
    
    init( id: String , name : String , screenName : String , mail : String , description : String, img : UIImage , followersCount : Int , friendsCount : Int )
    {
        self.id = id
        self.name = name
        self.screenName = screenName
        self.mail = mail
        self.image = img
        self.description = description
        self.followersCount = followersCount
        self.friendsCount = friendsCount
        self.isFollowByUser = false
    }
    
    init( id: String , name : String , screenName : String , mail : String , description : String, img : UIImage , followersCount : Int , friendsCount : Int , isFollowByUser : Bool )
    {
           self.id = id
           self.name = name
           self.screenName = screenName
           self.mail = mail
           self.image = img
           self.description = description
           self.followersCount = followersCount
           self.friendsCount = friendsCount
           self.isFollowByUser = isFollowByUser
    }
    
    func GetFollowByUser() ->Bool
    {
        return self.isFollowByUser
    }
    func getUID() -> String
    {
        return self.id!
    }
    
    func getName() -> String
    {
        return self.name!
    }
    
    func getScreenName() -> String
    {
        return self.screenName!
    }
    
    func getDescription() -> String
    {
        return self.description!
    }
    
    func getImage() -> UIImage
    {
        return self.image!
    }
    
    func getMail()  -> String
    {
        return self.mail!
    }
    
    
}
