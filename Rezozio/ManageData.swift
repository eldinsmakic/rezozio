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

class ManageData {
    
    private let db : Firestore
    private let data: [UserModel]
    
    init()
    {
        self.data = [UserModel(username: "jean", userIdent: "@Jean" , userBio: "Right now, Hello world to everry one.", img: #imageLiteral(resourceName: "ImgProfile1") ),UserModel(username: "carlos",userIdent: "@Carlos" , userBio: "Right now, lets explain what happens in the code above. Lets drink.", img: #imageLiteral(resourceName: "imgProfile2") ) , UserModel(username: "Artos",userIdent: "@Artos" , userBio: "I love you the more in that I believe you had liked me for my own sake and for nothing else ", img: #imageLiteral(resourceName: "imgProfile3") )]
        
        self.db = Firestore.firestore()
    }
    
    // return Fake data for now
    func getData() -> [UserModel]
    {
        return self.data
    }
    
    // Try to add New user to the database
    func addUserToDataBase(user : String , email : String , password : String) -> Bool
    {
        var result : Bool = true
        let data = self.createData(user: user, email: email, password: password)
    
        self.db.collection("utilisateurs").document(Auth.auth().currentUser!.uid).setData(data){
            err in
            if let err = err {
                result = false
            }
            result = true
        }
        return result
    }
    
    func getLength() -> Int
    {
        return self.data.count
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
}
