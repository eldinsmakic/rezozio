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
    
    var username: String?
    var userIdent: String?
    var image: UIImage?
    var userBio: String?
    
    init(username : String , userIdent: String , userBio: String, img : UIImage ) {
        self.username = username
        self.image = img
        self.userIdent = userIdent
        self.userBio = userBio
    }

}
