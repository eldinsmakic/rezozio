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
    self.data = [ThreadModel(username: "jean", img: #imageLiteral(resourceName: "HomeBar") ),ThreadModel(username: "carlos", img: #imageLiteral(resourceName: "HomeBar") )]
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
