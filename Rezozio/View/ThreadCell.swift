//
//  ThreadCell.swift
//  Rezozio
//
//  Created by eldin smakic on 28/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
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
        contentView.backgroundColor = .darkGray
        
        userLabel = UILabel()
        userLabel.backgroundColor = .green
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userIdentLabel = UILabel()
        userIdentLabel.backgroundColor = .purple
        userIdentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tweetTextView = UITextView()
        tweetTextView.backgroundColor = .yellow
        tweetTextView.translatesAutoresizingMaskIntoConstraints = false
        
        imgImageView = UIImageView()
        imgImageView.backgroundColor = .red
        imgImageView.clipsToBounds = true
        imgImageView.contentMode = .scaleAspectFill
        imgImageView.translatesAutoresizingMaskIntoConstraints = false
        
        followButton = UIButton()
        followButton.backgroundColor = .cyan
        followButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.addSubview(imgImageView)
        contentView.addSubview(userLabel)
        contentView.addSubview(userIdentLabel)
        contentView.addSubview(tweetTextView)
        contentView.addSubview(followButton)
    
        userLabel.topAnchor.constraint(equalTo: imgImageView.topAnchor ).isActive = true
        userLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor, constant: -12).isActive = true
        userLabel.leftAnchor.constraint(equalTo: imgImageView.rightAnchor, constant: 12).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        userIdentLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor , constant: 5).isActive = true
        userIdentLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor , constant: -12).isActive = true
        userIdentLabel.leftAnchor.constraint(equalTo: userLabel.leftAnchor ).isActive = true
        userIdentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        tweetTextView.topAnchor.constraint(equalTo: userIdentLabel.bottomAnchor , constant: 10).isActive = true
        tweetTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        tweetTextView.leftAnchor.constraint(equalTo: imgImageView.rightAnchor, constant: 12).isActive = true
        tweetTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        imgImageView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 12).isActive = true
        imgImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        imgImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imgImageView.heightAnchor.constraint(equalToConstant: 50 ).isActive = true
        
        followButton.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 12).isActive = true
        followButton.rightAnchor.constraint(equalTo: contentView.rightAnchor , constant: 12).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLandmark() {
        
        userLabel.text = threadModel?.username
        
        imgImageView.image = threadModel?.image
        
        userIdentLabel.text = threadModel?.userIdent
        
        tweetTextView.text = threadModel?.tweet
        
    }
    
    static var reuseIdentifier : String{
        return String(describing: self)
    }
    
    
}
