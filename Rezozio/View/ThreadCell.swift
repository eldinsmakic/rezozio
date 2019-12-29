//
//  ThreadCell.swift
//  Rezozio
//
//  Created by eldin smakic on 28/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//
// This class is a basic tweet format
//

import Foundation
import UIKit

class ThreadCell : UICollectionViewCell
{
    private var userLabel : UILabel!
    private var userIdentLabel : UILabel!
    private var imgImageView: UIImageView!
    private var tweetTextView : UITextView!
    private var followButton : UIButton!
    
    var threadModel: ThreadModel? {
        didSet {
            showLandmark()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //INIT ELEMENTS
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
        
        imgImageView = UIImageView()
        imgImageView.layer.cornerRadius = 5
        imgImageView.layer.masksToBounds = true
        imgImageView.clipsToBounds = true
        imgImageView.contentMode = .scaleAspectFill
        imgImageView.translatesAutoresizingMaskIntoConstraints = false
        
        followButton = UIButton()
        followButton.backgroundColor = .white
        followButton.layer.cornerRadius = 5
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = CGColor(srgbRed: 0, green: 255, blue: 255, alpha: 1)
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(UIColor(cgColor: CGColor(srgbRed: 0, green: 255, blue: 255, alpha: 1)), for: .normal )
        followButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        
        //ADD them to the view
        contentView.addSubview(imgImageView)
        contentView.addSubview(userLabel)
        contentView.addSubview(userIdentLabel)
        contentView.addSubview(tweetTextView)
        contentView.addSubview(followButton)
        
        
        //SETUP constraint
        userLabel.topAnchor.constraint(equalTo: imgImageView.topAnchor ).isActive = true
        userLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor, constant: -12).isActive = true
        userLabel.leftAnchor.constraint(equalTo: imgImageView.rightAnchor, constant: 12).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        userIdentLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor , constant: 5).isActive = true
        userIdentLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor , constant: -12).isActive = true
        userIdentLabel.leftAnchor.constraint(equalTo: userLabel.leftAnchor ).isActive = true
        userIdentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        tweetTextView.topAnchor.constraint(equalTo: userIdentLabel.bottomAnchor , constant: 10).isActive = true
        tweetTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        tweetTextView.leftAnchor.constraint(equalTo: imgImageView.rightAnchor, constant: 12).isActive = true
        tweetTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        imgImageView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 12).isActive = true
        imgImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        imgImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imgImageView.heightAnchor.constraint(equalToConstant: 50 ).isActive = true
        
        followButton.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 12).isActive = true
        followButton.rightAnchor.constraint(equalTo: contentView.rightAnchor , constant: -12).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // setup all elements of ThreadCell
    func showLandmark() {
        
        userLabel.text = threadModel?.username
        
        imgImageView.image = threadModel?.image
        
        userIdentLabel.text = threadModel?.userIdent
        
        tweetTextView.text = threadModel?.tweet
        
    }
    
    // Set a basic identifier name
    static var reuseIdentifier : String{
        return String(describing: self)
    }
    
    
}
