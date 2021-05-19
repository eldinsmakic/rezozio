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

    var userModel: UserModel? {
        didSet {
            showLandmark()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(profileImageView)
        contentView.addSubview(userLabel)
        contentView.addSubview(userIdentLabel)
        contentView.addSubview(userBioTextView)
        contentView.addSubview(followButton)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 12),
            profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50 ),

            followButton.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 12),
            followButton.rightAnchor.constraint(equalTo: contentView.rightAnchor , constant: -12),
            followButton.widthAnchor.constraint(equalToConstant: 120),
            followButton.heightAnchor.constraint(equalToConstant: 40),

            userLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor ),
            userLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor, constant: -12),
            userLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12),
            userLabel.heightAnchor.constraint(equalToConstant: 20),

            userIdentLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor , constant: 5),
            userIdentLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor , constant: -12),
            userIdentLabel.leftAnchor.constraint(equalTo: userLabel.leftAnchor ),
            userIdentLabel.heightAnchor.constraint(equalToConstant: 20),

            userBioTextView.topAnchor.constraint(equalTo: userIdentLabel.bottomAnchor , constant: 10),
            userBioTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            userBioTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12),
            userBioTextView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    // MARK: - UI Components

    private lazy var userLabel: UILabel = {
        let userLabel = UILabel()
        userLabel.font = UIFont.boldSystemFont(ofSize: 16)
        userLabel.translatesAutoresizingMaskIntoConstraints = false

        return userLabel
    }()

    private lazy var userIdentLabel: UILabel = {
        let userIdentLabel = UILabel()
        userIdentLabel.font = UIFont.boldSystemFont(ofSize: 14)
        userIdentLabel.textColor = .gray
        userIdentLabel.translatesAutoresizingMaskIntoConstraints = false

        return userIdentLabel
    }()

    private lazy var userBioTextView: UITextView = {
        let userBioTextView = UITextView()
        userBioTextView.font = UIFont.boldSystemFont(ofSize: 15)
        userBioTextView.translatesAutoresizingMaskIntoConstraints = false

        return userBioTextView
    }()

    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = 5
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        return profileImageView
    }()

    lazy var followButton: UIButton = {
        let followButton = UIButton()
        followButton.backgroundColor = .white
        followButton.layer.cornerRadius = 5
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = CGColor(srgbRed: 0, green: 255, blue: 255, alpha: 1)
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(UIColor(cgColor: CGColor(srgbRed: 0, green: 255, blue: 255, alpha: 1)), for: .normal )
        followButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        followButton.translatesAutoresizingMaskIntoConstraints = false

        return followButton
    }()

    private func setupButtonToUnfollow()
    {
        followButton.backgroundColor = .cyan
        followButton.setTitleColor(UIColor(red: 255, green: 255, blue: 250, alpha: 1), for: .normal)
        followButton.setTitle("Unfollow", for: .normal)
    }
    
    private func setupButtonToFollow()
    {
        followButton.backgroundColor = .white
        followButton.setTitleColor(UIColor(cgColor: CGColor(srgbRed: 0, green: 255, blue: 255, alpha: 1)), for: .normal )
        followButton.setTitle("Follow", for: .normal)
    }
    
    func changeTitleFollowButton()
    {
        
        if followButton.titleLabel!.text == "Follow"
        {
            self.setupButtonToUnfollow()
        }
        else
        {
            self.setupButtonToFollow()
        }
    }
    
    func initFollowButton()
    {
        if (userModel?.GetFollowByUser() == true)
        {
            self.setupButtonToUnfollow()
        }
        else
        {
            self.setupButtonToFollow()
        }
    }
    
    // setup all elements of ThreadCell
    func showLandmark() {
        
        userLabel.text = userModel?.getName()
        
        profileImageView.image = userModel?.getImage()
        
        userIdentLabel.text = "@" +  userModel!.getScreenName()
        
        userBioTextView.text = userModel?.getDescription()
        
        self.initFollowButton()
        
    }
    
    // Set a basic identifier name
    static var reuseIdentifier : String{
        return String(describing: self)
    }
    
    
}
