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
import FirebaseStorage
import AwaitKit
import PromiseKit


class ManageData {
    
    private let db : Firestore
    private let storage : Storage
    private let uid : String
    
    init()
    {

        self.db = Firestore.firestore()
        self.storage = Storage.storage()
        self.uid = Auth.auth().currentUser!.uid
    }
    
    
    /**
       Add new user to database (Firebase)
     - parameter user : the username
     - parameter email : user's email
    */
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
    
    
    /**
        Get All tweet in database,
        # Notes: #
         1. Tweets are return in a promise, you need to await it to gets
            array of tweets
         2. Handle return with a try
        # Example #
         ```
          let result = try! await(self.getTweets())
          ```
        
        - returns : a promise of an Array of tweets
         
    */
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
    
    
    /**
        Return All tweets order by time stored in database
        # Notes: #
         1. Tweets are return in a promise, you need to await it to gets
            array of tweets
         2. Handle return with a try
        # Example #
         ```
          let result = try! await(self.getTweetsOrdByTime())
          ```
        - returns : Promise of an Array of Tweets
    */
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
    
    /**
        Return All tweets stored in database order by time and which were created by users followed by
        logged user
        # Notes: #
         1. Tweets are return in a promise, you need to await it to gets
            array of tweets
         2. Handle return with a try
        # Example #
         ```
          let result = try! await(self.getTweetsOrdByTimeAndFollowByLoggedUser())
          ```
         # Usages #
         this function is use to get all tweets create by logged user and user that logged user follows
          then  return all  tweets to help create logged user feed page
        - returns : Promise of an Array of Tweets
    */
    func getTweetsOrdByTimeAndFollowByLoggedUser() -> Promise<[TweetModel]>
    {
        var result : [TweetModel] = []
        let tweetFollow = try! await(self.getTweetsIDFromUserThatLoggedUserFollow())
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
                               if (tweetFollow.contains(data.documentID))
                                {
                                    result.append(TweetFactory.factory.createTweetFromData(data: curData))
                                }
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
    
    /**
        Get all tweets'is id from all users followed by Logged user
         
        # Notes: #
         1. Tweets are return in a promise, you need to await it to gets
            array of tweets
         2. Handle return with a try
        # Example #
         ```
          let result = try! await(self.getTweetsIDFromUserThatLoggedUserFollow())
          ```
        # Usages #
            this function is use to get all users follow by logged  user then get all the tweets id  of
            user follow and return  a list of it. This list is use to create the feed page of logged User
        - returns : Promise of an Array of Tweets Id
    */
    func getTweetsIDFromUserThatLoggedUserFollow() -> Promise<[String]>
    {
        var result : [String] = []
        return Promise<[String]>
        {
            seal in
            var userfollow = try! await(self.getLoggedUserFolows())
            userfollow.append(self.uid)
                for user in userfollow
                {
                    let data = try! await(self.getTweetsIdFromUser(user_uid: user))
                    for tweetId in data
                    {
                        result.append(tweetId)
                    }
                    
                }
                seal.fulfill(result)
        }
        
    }
    
    
    
    /**
     
    get tweets id from an user #user_uid
        
      - Parameter user_uid: the user to get tweets id
     # Notes: #
      1. Users are return in a promise, you need to await it to gets
         array of tweets
      2. Handle return with a try
     # Example #
      ```
       let result = try! await(self.getTweetsIdFromUser(userB))
       ```
     # Usages #
         this function is use to get all tweets id from an user,
         use to create logged user feed page
     
    - returns : Promise of an Array of tweets id
    */
    private func getTweetsIdFromUser( user_uid : String) -> Promise<[String]>
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
    
    
    
    /**
        Get all users from database except logged user
         and return a list of users
        # Notes: #
         1. Users are return in a promise, you need to await it to gets
            array of tweets
         2. Handle return with a try
        # Example #
         ```
          let result = try! await(self.getUsers())
          ```
        # Usages #
            this function is use to get all users except logged user, will help to create
            the user list page, where logged user can follow or  unfollow user
        - returns : Promise of an Array of users
    */
    func getUsers() -> Promise<[UserModel]>
    {
        let uid = Auth.auth().currentUser!.uid
        let followedUser = try! await(self.getLoggedUserFolows())
        var result : [UserModel] =  []
        var isFollow = false
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
                                    isFollow = false
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
    
    /**
        Add or remove a user's follow depending if user is already follow or  not
         - parameter uid : the user to follow or unfollow
        # Usages #
        this function is use to follow or unfollow user by the logged user
    */
    func changeUserFollows(uid : String)
    {
        async {
            var user_follow : [String] = try! await(self.getLoggedUserFolows())
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
    
     /**
           Get all users that are followed by logged user
           and return a list of users id
           # Notes: #
            1. Users uid  are return in a promise, you need to await it to gets
               array of tweets
            2. Handle return with a try
           # Example #
            ```
             let result = try! await(self.getLoggedUserFolows())
             ```
           # Usages #
               this function is use to get all users that are follow by logged user
           - returns : Promise of an Array of user id
       */
    func getLoggedUserFolows() -> Promise<[String]>
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
    

    
    
     /**
              Get info of logged user and return a user object
              
              # Notes: #
               1. User is return in a promise, you need to await it to get
                  user
               2. Handle return with a try
              # Example #
               ```
                let result = try! await(self.getUserInfoAsync())
                ```
              - returns : Promise of an Array of user
          */
    func getLoggedUserInfoAsync() -> Promise<UserModel>
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
    
    
    /**
        Add Tweet to database and return the Tweet uid
        # Notes: #
         1. Tweet id is return in a promise, you need to await it to get it
         2. Handle return with a try
        # Example #
         ```
          let tweetId = try! await(self.AddTweet())
          ```
        # Usages #
            this function is use to save tweet to database and get tweet id to use it
          and add it to user's tweet id list
        - returns : Promise of a tweet id
    */
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
    
     /**
           Add Tweet to user's tweet id list
           
           # Example #
            ```
             let tweetId = try! await(self.AddTweet())
             self.addTweetToLoggedUser(tweetId)
             ```
           # Usages #
               this function is use to save tweet id to  user's  tweet id list,
               this list help to retrieve all tweet of an user
       */
    func addTweetToLoggedUser( tweetUID : String)
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
    
    
    ///  Get profile photo of an user ```user_uid ```
    ///
    /// - Parameter user_uid: user_uid to get profile photo
    /// - returns : a promise an image
    func getUserProfilePhoto( user_uid: String) -> Promise<UIImage>
    {
        return Promise<UIImage>
        {
            seal in
            db.collection("utilisateurs").document(user_uid).getDocument
            {
                (document, error) in
                                if error != nil
                                {
                                    print("can't fetch profile picture")
                                    seal.reject(error!)
                                }
                                else
                                {
                                    if (document!.exists)
                                    {
                                        print("Tring to fetch profile image")
                                        let data = document?.data()
                                        let url =  data!["profile_image"] as! String
                                        print("the main url is \(url) ")
                                        let ref = self.storage.reference(forURL: url)
                                        ref.downloadURL
                                        {
                                            (URL, Error) in
                                            print("en cours")
                                            let data = NSData(contentsOf: URL!)
                                            let image = UIImage(data: data! as Data)!
                                            print("reussite de la photo")
                                            seal.fulfill(image)
                                        }
                                    }
                                }
            }
            
        }
    }
    
    /**
     Get Logger User Tweets Id and return an array of it
     # Notes: #
     1. Tweet id is return in a promise, you need to await it to get it
     2. Handle return with a try
     # Example #
     ```
     var tweetId = try! await(self.getUserTweetId())
     tweetId.append(tweetUID)
     // then upload new array to database
     ```
     # Usages #
     this function is get all tweet id from logged user, and add/delete a tweet id with addTweetToUser()
      
     - returns : Promise of a tweet id
     */
    private func getUserTweetId() -> Promise<[String]>
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
