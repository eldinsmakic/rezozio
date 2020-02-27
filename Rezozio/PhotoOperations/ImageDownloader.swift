//
//  ImageDownloader.swift
//  Rezozio
//
//  Created by eldin smakic on 26/02/2020.
//  Copyright © 2020 eldin smakic. All rights reserved.
//

import UIKit
import AwaitKit
/// Operation on Image
/// Download Image and check for errors during download
class ImageDownloader: Operation {
  
  let photoRecord: PhotoRecord
    let manageData: ManageData
  
  init(_ photoRecord: PhotoRecord) {
    self.photoRecord = photoRecord
    self.manageData = ManageData()
  }
  
  
  override func main() {
    
    if isCancelled {
      return
    }
    let imageData = try?  await(self.manageData.getUserProfilePhotoWithUrl(user_url: self.photoRecord.url))
    
    if isCancelled {
      return
    }
    
    
    if (imageData != nil){
      photoRecord.image = imageData
      photoRecord.state = .downloaded
    } else {
      photoRecord.state = .failed
      photoRecord.image = UIImage(named: "Failed")
    }
  }
}
