//
//  ManageData.swift
//  Rezozio
//
//  Created by eldin smakic on 28/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//

import Foundation


class ManageData {
    private let data: [UserModel]
    init()
    {
        self.data = [UserModel(username: "jean", userIdent: "@Jean" , userBio: "Right now, Hello world to everry one.", img: #imageLiteral(resourceName: "ImgProfile1") ),UserModel(username: "carlos",userIdent: "@Carlos" , userBio: "Right now, lets explain what happens in the code above. Lets drink.", img: #imageLiteral(resourceName: "imgProfile2") ) , UserModel(username: "Artos",userIdent: "@Artos" , userBio: "I love you the more in that I believe you had liked me for my own sake and for nothing else ", img: #imageLiteral(resourceName: "imgProfile3") )]
    }
    
    func getData() -> [UserModel]
    {
        return self.data
    }
    
    func getLength() -> Int
    {
        return self.data.count
    }

}
