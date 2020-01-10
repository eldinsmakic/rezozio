//
//  UserFactory.swift
//  Rezozio
//
//  Created by eldin smakic on 08/01/2020.
//  Copyright © 2020 eldin smakic. All rights reserved.
//
//  All Utilities to create user to bind data from firebase


import UIKit
import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserFactory {
    public static let factory = UserFactory()
    
    
    public func createUserFromData(data : [String : Any]) -> UserModel?
    {
        return nil
    }
    
    public func createDataFromUser(user : UserModel) -> [String : Any]
    {
       
            return [
                  "id" : 0,
                  "name" : user.getName(),
                  "screen_name" : user.getName(),
                  "mail" : user.getMail(),
                  "description" : user.getDescription(),
                  "profile_image" : "",
                  "followers_count" : 0,
                  "friends_count" : 0,
                  "create_at" : Timestamp(date: Date())
                   ]
    }
    
    public func createDataForNewUser(user : String , email : String ) -> [String : Any]
    {
        return    [
                               "id" : 0,
                               "name" : user,
                               "screen_name" : user,
                               "mail" : email,
                               "description" : "",
                               "profile_image" : "",
                               "followers_count" : 0,
                               "friends_count" : 0,
                               "create_at" : Timestamp(date: Date())
                                ]
    }
}
