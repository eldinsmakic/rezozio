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
    private var user : UILabel!
    private var img: UIImageView!
    
    var threadModel: ThreadModel? {
        didSet {
            showLandmark()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .darkGray
        
        user = UILabel()
        user.numberOfLines = 0
        user.textAlignment = .center
        user.translatesAutoresizingMaskIntoConstraints = false
        
        img = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        img.clipsToBounds = true
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(img)
        contentView.addSubview(user)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLandmark() {
        
        user.text = threadModel?.username
        
        img.image = threadModel?.image
        
    }
    
    static var reuseIdentifier : String{
        return String(describing: self)
    }
    
    
}
