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
    private var data: [TweetModel]
    
    init()
    {

        self.data = []
        self.db = Firestore.firestore()
        self.data = [TweetModel(username: "jean", userIdent: "@Jean" , tweet: "Right now, Hello world to everry one.", img: #imageLiteral(resourceName: "ImgProfile1") ),TweetModel(username: "carlos",userIdent: "@Carlos" , tweet: "Right now, lets explain what happens in the code above. Lets drink.", img: #imageLiteral(resourceName: "imgProfile2") ) , TweetModel(username: "Artos",userIdent: "@Artos" , tweet: "I love you the more in that I believe you had liked me for my own sake and for nothing else ", img: #imageLiteral(resourceName: "imgProfile3") )]
    }
    
    
    // return Fake data for now
    func getData() -> [TweetModel]
    {
        return self.data
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
                                    let currentUser = UserFactory.factory.createUserFromDataWithUID(uid: data.documentID ,  data: data.data())!
                                    result.append(currentUser)
                                }
                                   
                            }
                            seal.fulfill(result)
                        }
                        
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
    func AddTweet(data : [String : Any]) -> Promise<Bool>
    {
        return Promise<Bool>
            {
                seal in
                db.collection("tweets").document().setData(data)
                {
                    Error in
                    if (Error != nil)
                    {
                        seal.reject(Error!)
                    }
                    seal.fulfill(true)
                    
                }
            }
    }
    
    
    
}
extension Notification.Name {
static let didReceiveData = Notification.Name("didReceiveData")
}
