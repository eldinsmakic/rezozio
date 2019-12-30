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

class TweetCell : UICollectionViewCell
{
    
    private var userLabel : UILabel!
    private var userIdentLabel : UILabel!
    private var profileImageView : UIImageView!
    private var tweetTextView : UITextView!
    
    var userModel: UserModel? {
        didSet {
            showLandmark()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        
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
    
    func showLandmark() {
        
        userLabel.text = userModel?.username
        
        profileImageView.image = userModel?.image
        
        userIdentLabel.text = userModel?.userIdent
        
        tweetTextView.text = userModel?.userBio
        
    }
    
    // Set a basic identifier name
       static var reuseIdentifier : String{
           return String(describing: self)
       }
    
    
}
