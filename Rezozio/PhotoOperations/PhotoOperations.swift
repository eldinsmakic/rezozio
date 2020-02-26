//
//  PhotoOperations.swift
//  Rezozio
//
//  Created by eldin smakic on 26/02/2020.
//  Copyright © 2020 eldin smakic. All rights reserved.
//
// Contains all basics utilities for a photo download


import UIKit


/// Show different state of a photo
/// if its a new photo , download, failed to download.
enum PhotoRecordState
{
    case new, downloaded, filtered, failed
}

/// Represent a photo with its current state
/// Here a photo is only an URL
class PhotoRecord
{
    let name: String
    let url: URL
    var state = PhotoRecordState.new
    var image = UIImage(named: "Placeholder")
    
    init(name:String , url:URL) {
        self.name = name
        self.url = url
    }
}


/// Controls photo operations
class PendingOperations
{
  lazy var downloadsInProgress: [IndexPath: Operation] = [:]
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
  lazy var filtrationsInProgress: [IndexPath: Operation] = [:]
  lazy var filtrationQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Image Filtration queue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
}
