//
//  ManageData.swift
//  Rezozio
//
//  Created by eldin smakic on 28/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import AwaitKit
import PromiseKit


class ManageData {
    
    private let db : Firestore
    private let uid : String
    init()
    {

        self.db = Firestore.firestore()
        self.uid = Auth.auth().currentUser!.uid
    }
    
    
    // Try to add New user to the database
    func addUserToDataBase(user : String , email : String ) -> Bool
    {
        var result : Bool = true
        let data = UserFactory.factory.createDataForNewUser(user: user, email: email)
        self.db.collection("utilisateurs").document(Auth.auth().currentUser!.uid).setData(data){
            err in
            if let err = err {
                result = false
            }
            result = true
        }
        return result
    }
    
    
    // Return All tweet in database
    func getTweets() -> Promise<[TweetModel]>
    {
        var result : [TweetModel] = []
        return Promise<[TweetModel]>
        {
            seal in
            self.db.collection("tweets").getDocuments
            {
                (document, Error) in
                    if let document  =  document , !document.isEmpty
                    {
                        for data in document.documents
                            {
                                let curData = data.data()
                                result.append(TweetFactory.factory.createTweetFromData(data: curData))
                            }
                        seal.fulfill(result)
                    }
                    else
                    {
                        seal.reject(Error!)
                    }
            }
        }
    }
    
    
    // Return All tweet in database
    func getTweetsOrdByTime() -> Promise<[TweetModel]>
    {
        var result : [TweetModel] = []
        return Promise<[TweetModel]>
        {
            seal in
            self.db.collection("tweets").order(by: "create_at", descending: true).getDocuments
            {
                (document, Error) in
                    if let document  =  document , !document.isEmpty
                    {
                        for data in document.documents
                            {
                                let curData = data.data()
                                result.append(TweetFactory.factory.createTweetFromData(data: curData))
                            }
                        seal.fulfill(result)
                    }
                    else
                    {
                        seal.reject(Error!)
                    }
            }
        }
    }
    
    func getTweetsOrdByTimeAndFollowByUser() -> Promise<[TweetModel]>
    {
        var result : [TweetModel] = []
        let follow = try! await(self.getUserFolows())
        return Promise<[TweetModel]>
        {
            seal in
            self.db.collection("tweets").order(by: "create_at", descending: true).getDocuments
            {
                (document, Error) in
                    if let document  =  document , !document.isEmpty
                    {
                        for data in document.documents
                            {
                                let curData = data.data()
                                result.append(TweetFactory.factory.createTweetFromData(data: curData))
                            }
                        seal.fulfill(result)
                    }
                    else
                    {
                        seal.reject(Error!)
                    }
            }
        }
    }
    
    // return a array of all tweetID from all user that logged
    // User follow
    func getTweetsIDFromUserThatUserFollow() -> Promise<[String]>
    {
        var result : [String] = []
        return Promise<[String]>
        {
            seal in
                let userfollow = try! await(self.getUserFolows())
                for user in userfollow
                {
                    let data = try! await(self.getTweetsArrayFromUser(user_uid: user))
                    for tweetId in data
                    {
                        result.append(tweetId)
                    }
                    
                }
                seal.fulfill(result)
        }
        
    }
    
    // return all tweets ID from an user
    func getTweetsArrayFromUser( user_uid : String) -> Promise<[String]>
    {
        return Promise<[String]>
            {
                seal in
                self.db.collection("tweetsId").document(user_uid).getDocument
                    {
                        (document , error) in
                        if error != nil
                        {
                            seal.reject(error!)
                        }
                        else
                        {
                            if (document!.exists)
                            {
                                let data = document!.data()
                                seal.fulfill(data!["tweetsId"] as! [String])
                            }
                            else
                            {
                                seal.fulfill([])
                            }
                        }
                    }
                
            }
    }
    
    
    
    // Get all user that can be follow by the app user
    func getUsers() -> Promise<[UserModel]>
    {
        let uid = Auth.auth().currentUser!.uid
        let followedUser = try! await(self.getUserFolows())
        var result : [UserModel] =  []
        return Promise<[UserModel]>
        {
            seal in
            self.db.collection("utilisateurs").getDocuments
                {
                    (QuerySnapshot, Error) in
                    if (Error != nil) {
                        seal.reject(Error!)
                    }
                    else
                    {
                        if  QuerySnapshot != nil
                        {
                            for data in QuerySnapshot!.documents
                            {
                                
                                if (data.documentID  !=  uid)
                                {
                                    var isFollow = false
                                    if (followedUser.contains(data.documentID))
                                    {
                                        isFollow = true
                                    }
                                    let currentUser = UserFactory.factory.createUserFromDataWithFollowWithUID(isFollowByUser: isFollow,uid: data.documentID ,  data: data.data())!
                                    result.append(currentUser)
                                }
                                   
                            }
                            seal.fulfill(result)
                        }
                }
            }
        }
    }
    
    //Follow a new user
    func addOrRemoveUserFollow(uid : String)
    {
        async {
            var user_follow : [String] = try! await(self.getUserFolows())
            if (user_follow.contains(uid) )
            {
                user_follow.remove(at: user_follow.firstIndex(of: uid)!)
            }
            else
            {
                user_follow.append(uid)
            }
               let user_uid = Auth.auth().currentUser!.uid
               self.db.collection("follow").document(user_uid).setData(["follows" : user_follow , "userId" : ""]){
                   err in
                   if let err = err {
                      print(err)
                   }
                   else
                   {
                       print("succes")
                   }
               }
        }
    }
    
    // Get all user followed by logged user
    func getUserFolows() -> Promise<[String]>
    {
        let uid = Auth.auth().currentUser!.uid
        return Promise<[String]>
        {
            seal in
            self.db.collection("follow").document(uid).getDocument
                {
                    (document, error) in
                    if error != nil
                    {
                        seal.reject(error!)
                    }
                    else
                    {
                        let datas = document!.data()
                        if datas !=  nil
                        {
                            seal.fulfill(datas!["follows"] as! [String])
                        }
                        else
                        {
                           
                            seal.fulfill([] as! [String])
                        }
                    }
                }
        }
    }
    
    // Create Data type for the Database
    private func createData(user : String , email : String , password : String) -> [String : Any]
    {
        return [
              "user" : user,
              "mail" : email,
              "password" : password,
              "bio" :  "",
              "profile" : "",
              "signedIng" : Timestamp(date: Date())
               ]
    }
    

    
    
    
    // return user info
    func getUserInfoAsync() -> Promise<UserModel>
    {
           
            return Promise<UserModel>
                {
                    seal in
                           let uid = Auth.auth().currentUser!.uid
                           db.collection("utilisateurs").document(uid).getDocument
                           {
                                (document, Error) in
                                       if let document =  document , document.exists
                                       {
                                        let res = document.data()
                                        let user = UserModel(id: uid, name: res!["name"] as! String, screenName: res!["screen_name"] as! String, mail : res!["mail"]  as! String , description: res!["description"] as! String, img: #imageLiteral(resourceName: "ImgProfile1"), followersCount: res!["followers_count"] as! Int, friendsCount: res!["friends_count"] as! Int )
                                         seal.fulfill(user)
                                           
                                       }
                                      else
                                       {
                                        print(Error.debugDescription)
                                            seal.reject(Error!)
                                       }
                                        
                           }
              }
    }
    
    
    // Add new tweet to database
    func AddTweet(data : [String : Any]) -> Promise<String>
    {
        return Promise<String>
            {
                seal in
                
                let ref = db.collection("tweets").document()
                ref.setData(data)
                {
                    Error in
                    if (Error != nil)
                    {
                        seal.reject(Error!)
                    }
                    seal.fulfill(ref.documentID)
                    
                }
                
            }
    }
    
    // add a tweet id to the user list tweet id
    func addTweetToUser( tweetUID : String)
    {
        var tweetId = try! await(self.getUserTweetId())
        tweetId.append(tweetUID)
        db.collection("tweetsId").document(uid).setData(["tweetsId": tweetId])
        {
            error in
            if error != nil
            {
                print(error)
            }
            else
            {
                print("Tweet Added To TWeetsID")
            }
        }
    }
    
    // return an ilist of all user tweet's Id
    func getUserTweetId() -> Promise<[String]>
    {
        
        return Promise<[String]>
            {
                seal in
                db.collection("tweetsId").document(uid).getDocument
                {
                    (document, error) in
                    if (error != nil)
                    {
                        seal.reject(error!)
                    }
                    else
                    {
                        var tweets : [String] = []
                        if (document!.exists)
                        {
                            let data =  document?.data()
                            tweets = data!["tweetsId"] as! [String]
                            seal.fulfill(tweets)
                        }
                        else
                        {
                            seal.fulfill(tweets)
                        }
                        
                    }
                }
            }
    }
    
    
}
extension Notification.Name {
static let didReceiveData = Notification.Name("didReceiveData")
}
