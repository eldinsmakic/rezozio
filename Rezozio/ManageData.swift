//
//  ManageData.swift
//  Rezozio
//
//  Created by eldin smakic on 28/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//

import Foundation


class ManageData {
    private let data: [ThreadModel]
    init()
    {
    self.data = [ThreadModel(username: "jean", userIdent: "@Jean" , tweet: "Right now, lets explain what happens in the code above. We defined a struct Person with two stored properties name and age.", img: #imageLiteral(resourceName: "HomeBar") ),ThreadModel(username: "carlos",userIdent: "@Carlos" , tweet: "Right now, lets explain what happens in the code above. We defined a struct Person with two stored properties name and age.", img: #imageLiteral(resourceName: "HomeBar") )]
    }
    
    func getData() -> [ThreadModel]
    {
        return self.data
    }
    
    func getLength() -> Int
    {
        return self.data.count
    }

}
