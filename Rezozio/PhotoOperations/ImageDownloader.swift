//
//  ImageDownloader.swift
//  Rezozio
//
//  Created by eldin smakic on 26/02/2020.
//  Copyright © 2020 eldin smakic. All rights reserved.
//

import UIKit

/// Operation on Image
/// Download Image and check for errors during download
class ImageDownloader: Operation {
  
  let photoRecord: PhotoRecord
  
  
  init(_ photoRecord: PhotoRecord) {
    self.photoRecord = photoRecord
  }
  
  
  override func main() {
    
    if isCancelled {
      return
    }

    
    guard let imageData = try? Data(contentsOf: photoRecord.url) else { return }
    
    if isCancelled {
      return
    }
    
    if !imageData.isEmpty {
      photoRecord.image = UIImage(data:imageData)
      photoRecord.state = .downloaded
    } else {
      photoRecord.state = .failed
      photoRecord.image = UIImage(named: "Failed")
    }
  }
}
