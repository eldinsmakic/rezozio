//
//  TweetCell.swift
//  Rezozio
//
//  Created by eldin smakic on 29/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//
// This class is a basic tweet
// using collectionCell to represent it


import Foundation
import UIKit
import AwaitKit
import PromiseKit


class TweetCell : UICollectionViewCell
{
    
    private var userLabel : UILabel!
    private var userIdentLabel : UILabel!
    private var profileImageView : UIImageView!
    private var tweetTextView : UITextView!
    private var manageData : ManageData
    public static var imageCache = NSCache<NSString, UIImage>()
    
    var tweetModel: TweetModel? {
        didSet {
            showLandmark()
        }
    }
    
    override init(frame: CGRect) {
       self.manageData =  ManageData()
       super.init(frame : frame)
       self.setupBorder()
       
       userLabel = UILabel()
       userLabel.font = UIFont.boldSystemFont(ofSize: 16)
       userLabel.translatesAutoresizingMaskIntoConstraints = false
       
       userIdentLabel = UILabel()
       userIdentLabel.font = UIFont.boldSystemFont(ofSize: 14)
       userIdentLabel.textColor = .gray
       userIdentLabel.translatesAutoresizingMaskIntoConstraints = false
       
       tweetTextView = UITextView()
       tweetTextView.font  = UIFont.boldSystemFont(ofSize: 15)
       tweetTextView.translatesAutoresizingMaskIntoConstraints = false
       
       profileImageView = UIImageView()
       profileImageView.layer.cornerRadius = 5
       profileImageView.layer.masksToBounds = true
       profileImageView.clipsToBounds = true
       profileImageView.contentMode = .scaleAspectFill
       profileImageView.translatesAutoresizingMaskIntoConstraints = false
       
       
       //ADD them to the view
       contentView.addSubview(profileImageView)
       contentView.addSubview(userLabel)
       contentView.addSubview(userIdentLabel)
       contentView.addSubview(tweetTextView)
       
       
       //SETUP constraint
       userLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor ).isActive = true
       userLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
       userLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
       userLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
       
       userIdentLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor , constant: 5).isActive = true
       userIdentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor , constant: 30).isActive = true
       userIdentLabel.leftAnchor.constraint(equalTo: userLabel.leftAnchor ).isActive = true
       userIdentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

       tweetTextView.topAnchor.constraint(equalTo: userIdentLabel.bottomAnchor , constant: 10).isActive = true
       tweetTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
       tweetTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
       tweetTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
       
       profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 12).isActive = true
       profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
       profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
       profileImageView.heightAnchor.constraint(equalToConstant: 50 ).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBorder()
    {
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = .init(srgbRed: 10, green: 10, blue: 10, alpha: 1)
        self.contentView.layer.cornerRadius = 5
    }
    
    func showLandmark() {
        
        userLabel.text = tweetModel?.username
        
        profileImageView.image = tweetModel?.image
        
        userIdentLabel.text = "@" + tweetModel!.userIdent!
        
        tweetTextView.text = tweetModel?.tweet
        
        
    }
    
    func setupImage()
          {
              async {
                let url = self.tweetModel!.getUserImageLink()
                if let image = TweetCell.self.imageCache.object(forKey: url as NSString)  {
                       DispatchQueue.main.async {
                           self.profileImageView.image = image
                       }                }
                else
                {
                       let image = try! await(self.manageData.getUserProfilePhotoWithUrl(user_url: url))
                       TweetCell.self.imageCache.setObject(image, forKey: url as NSString)
                       DispatchQueue.main.async {
                           self.profileImageView.image = image
                       }
                }

              }
              
          }
    
    // Set a basic identifier name
       static var reuseIdentifier : String{
           return String(describing: self)
       }
    
    
}
