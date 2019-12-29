//
//  UserCell.swift
//  Rezozio
//
//  Created by eldin smakic on 28/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//
// This class is a basic user cell of tweeter
// where you can see the picture, name, username and bio
// and follow or not this user
//

import Foundation
import UIKit

class UserCell : UICollectionViewCell
{
    private var userLabel : UILabel!
    private var userIdentLabel : UILabel!
    private var profileImageView: UIImageView!
    private var userBioTextView : UITextView!
    private var followButton : UIButton!
    
    var userModel: UserModel? {
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
        
        userBioTextView = UITextView()
        userBioTextView.font  = UIFont.boldSystemFont(ofSize: 15)
        userBioTextView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = 5
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
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
        contentView.addSubview(profileImageView)
        contentView.addSubview(userLabel)
        contentView.addSubview(userIdentLabel)
        contentView.addSubview(userBioTextView)
        contentView.addSubview(followButton)
        
        
        //SETUP constraint
        userLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor ).isActive = true
        userLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor, constant: -12).isActive = true
        userLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        userIdentLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor , constant: 5).isActive = true
        userIdentLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor , constant: -12).isActive = true
        userIdentLabel.leftAnchor.constraint(equalTo: userLabel.leftAnchor ).isActive = true
        userIdentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        userBioTextView.topAnchor.constraint(equalTo: userIdentLabel.bottomAnchor , constant: 10).isActive = true
        userBioTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        userBioTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        userBioTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 12).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50 ).isActive = true
        
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
        
        userLabel.text = userModel?.username
        
        profileImageView.image = userModel?.image
        
        userIdentLabel.text = userModel?.userIdent
        
        userBioTextView.text = userModel?.userBio
        
    }
    
    // Set a basic identifier name
    static var reuseIdentifier : String{
        return String(describing: self)
    }
    
    
}
