//
//  MainViewController.swift
//  Rezozio
//
//  Created by eldin smakic on 26/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import AwaitKit
import PromiseKit


class MainViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    private let  headerId = "headerId"
    private let  footerId = "footerId"
    private var managerData : ManageData
    private var data : [TweetModel] = []
    private var imageCache : NSCache<NSString, UIImage>
    var photos: [PhotoRecord] = []
    let pendingOperations = PendingOperations()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        self.managerData = ManageData()
        self.imageCache = NSCache<NSString, UIImage>()
        super.init(collectionViewLayout: layout)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCells()
        self.setupNavigationBar()
        self.fetchTweet()
    }
    
    func fetchTweet()
    {
        async {
            let res = try! await(self.managerData.getTweetsOrdByTimeAndFollowByLoggedUser())
            self.data = res
            self.fetchPhotoDetails()
            DispatchQueue.main.async {
                 self.collectionView.reloadData()
            }
        }
    }
    
    func fetchPhotoDetails()
    {
        for data in self.data {
            let url  = data.getUserImageLink()
            let photoRecord = PhotoRecord(name: "name", url: url)
            self.photos.append(photoRecord)
        }
        
        
        DispatchQueue.main.async {
                 UIApplication.shared.isNetworkActivityIndicatorVisible = false
                 self.collectionView.reloadData()
               }
    }
    
    func startOperations(for photoRecord: PhotoRecord, at indexPath: IndexPath)
    {
        startDownload(for: photoRecord, at: indexPath)
    }
    

    func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
      //1
      guard pendingOperations.downloadsInProgress[indexPath] == nil else {
        return
      }
          
      //2
      let downloader = ImageDownloader(photoRecord)
      
      //3
      downloader.completionBlock = {
        if downloader.isCancelled {
          return
        }

        DispatchQueue.main.async {
          self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
          self.collectionView.reloadItems(at: [indexPath])
        }
      }
      
      //4
      pendingOperations.downloadsInProgress[indexPath] = downloader
      
      //5
      pendingOperations.downloadQueue.addOperation(downloader)
    }
    

    /// add images to tweets
    /// using cache to help to reduce request time
    func setupImages(at indexPath: IndexPath)
    {
        async {
                let start = Date()
                for data in self.data
                {
                    
                    let url = data.getUserImageLink()
                    if let image = self.imageCache.object(forKey: url as NSString) as? UIImage {
                        data.setImage(image: image)
                    }
                    else
                    {
                        let image = try! await(self.managerData.getUserProfilePhotoWithUrl(user_url: url))
                        self.imageCache.setObject(image, forKey: url as NSString)
                        data.setImage(image: image)
                    }
                     DispatchQueue.main.async {
                        self.collectionView.reloadItems(at:[indexPath])
                    }
                }
//                 DispatchQueue.main.async {
//                 self.collectionView.reloadData()
//                let finish = Date()
//                print("Time lapsed \(finish.timeIntervalSince(start))")
//            }
             
        }
    }
    
    func setupImage(data:TweetModel)
    {
        async{
                    let start = Date()
                    let url = data.getUserImageLink()
                    if let image = self.imageCache.object(forKey: url as NSString) {
                        data.setImage(image: image)
                    }
                    else
                    {
                        let image = try! await(self.managerData.getUserProfilePhotoWithUrl(user_url: url))
                        self.imageCache.setObject(image, forKey: url as NSString)
                        data.setImage(image: image)
                    }
                
                    DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    let finish = Date()
                    print("Time lapsed \(finish.timeIntervalSince(start))")
            }
        }
    }
    
    func setupCells()
    {
        collectionView.backgroundColor = .white
        collectionView.register( TweetCell.self , forCellWithReuseIdentifier: TweetCell.reuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
    }
    
    func setupNavigationBar()
    {
       
        setupLeftButton()
        setupRightButton()
        setupRemainingButton()
      
    }
    
    private func setupRemainingButton()
    {
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        titleImageView.image = #imageLiteral(resourceName: "HomeBar")
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        navigationItem.titleView = titleImageView
    }
    
    private func setupRightButton()
    {
        
      let searchButton = UIButton(type: .system)
      searchButton.setImage(#imageLiteral(resourceName: "searchIcon").withRenderingMode(.alwaysOriginal), for: .normal)
      searchButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
      searchButton.imageView?.contentMode = .scaleAspectFit
      searchButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
      searchButton.addTarget(self, action :  #selector(searchOnClick) , for: .touchUpInside)
        
      
      let composeButton = UIButton(type: .system)
      composeButton.setImage(#imageLiteral(resourceName: "ComposeIcon").withRenderingMode(.alwaysOriginal), for: .normal)
      composeButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
      composeButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
      composeButton.addTarget(self, action: #selector(composeOnClick)  , for: .touchUpInside)
      
      navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: composeButton), UIBarButtonItem(customView: searchButton)]
    }
    
    // When click search button change view
    @objc func searchOnClick(_ sender : UIBarButtonItem)
    {
        print("searching")
    }
    
    @objc func composeOnClick(_ sender : UIBarButtonItem)
    {
        let tweetVC = TweetViewController()
        navigationController?.pushViewController(tweetVC, animated: true)
    }
    
    // When click on follow button change view to FollowUsers
    @objc func followOnClick(_ sender : UIBarButtonItem)
    {
        let followVC = FollowUsersController(collectionViewLayout : UICollectionViewFlowLayout())
        navigationController?.pushViewController( followVC, animated: true)
    }
    
    
    private func setupLeftButton()
    {
        let followButton = UIButton(type: .system)
        followButton.setImage(#imageLiteral(resourceName: "test").withRenderingMode(.alwaysOriginal), for: .normal)
        followButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        followButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        followButton.imageView?.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: followButton)
        followButton.addTarget(self, action: #selector(followOnClick)  , for: .touchUpInside)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.reuseIdentifier, for: indexPath) as! TweetCell
        let tweetModel = self.data[indexPath.item]
        if !collectionView.isDragging && !collectionView.isDecelerating
        {
            let photoDetails = photos[indexPath.item]
            switch (photoDetails.state) {
             case .failed:
               print("Failed to load \(indexPath.item) ")
             case .new:
               print("new Photo")
               startOperations(for: photoDetails, at: indexPath)
            case .filtered,.downloaded:
                print("Setting Image")
                tweetModel.image = photoDetails.image
            }
        }
        cell.tweetModel = tweetModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width , height: 150)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader)
        {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
            let label :  UILabel = {
                      let label = UILabel()
                      label.text = "Recent Tweet"
                      label.textColor = .black
                      label.font = UIFont.boldSystemFont(ofSize: 17)
                      label.translatesAutoresizingMaskIntoConstraints = false
                      return label
                  }()
            header.addSubview(label)
            label.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: header.topAnchor ).isActive = true
            return header
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        let label :  UILabel = {
            let label = UILabel()
            label.text = "Show me more"
            label.textColor = .systemBlue
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        footer.addSubview(label)
        label.leftAnchor.constraint(equalTo: footer.leftAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: footer.topAnchor ).isActive = true
        return footer
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width , height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width , height: 100)
    }
}
