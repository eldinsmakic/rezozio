//
//  FollowUsersController.swift
//  Rezozio
//
//  Created by eldin smakic on 31/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//

import UIKit

class FollowUsersController: UICollectionViewController , UICollectionViewDelegateFlowLayout {

    private let  headerId = "headerId"
    private let  footerId = "footerId"
    private var managerData : ManageData
    private var data : [UserModel]
    override init(collectionViewLayout layout: UICollectionViewLayout) {
           self.managerData = ManageData()
           self.data = self.managerData.getUserData()
           super.init(collectionViewLayout: layout)
       }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCells()
        self.setupNavigationBar()

        // Do any additional setup after loading the view.
    }
    
     func setupCells()
        {
            collectionView.backgroundColor = .white
            collectionView.register( UserCell.self , forCellWithReuseIdentifier: UserCell.reuseIdentifier)
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
            let titleButon =  UIButton()
            titleButon.addSubview(titleImageView)
            titleButon.addTarget(self, action: #selector(homeIconOnClick), for: .touchUpInside)
            navigationItem.titleView = titleButon
            
            
        }
        
        @objc func homeIconOnClick(_ sender : UIBarButtonItem)
        {
            let  mainVc = MainViewController(collectionViewLayout: UICollectionViewFlowLayout())
            navigationController?.pushViewController(mainVc, animated: true)
        }
        
        private func setupRightButton()
        {
            
          let searchButton = UIButton(type: .system)
          searchButton.setImage(#imageLiteral(resourceName: "searchIcon").withRenderingMode(.alwaysOriginal), for: .normal)
          searchButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
          searchButton.imageView?.contentMode = .scaleAspectFit
          searchButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
          
          
          let composeButton = UIButton(type: .system)
          composeButton.setImage(#imageLiteral(resourceName: "ComposeIcon").withRenderingMode(.alwaysOriginal), for: .normal)
          composeButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
          composeButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
          composeButton.addTarget(self, action: #selector(composeOnClick)  , for: .touchUpInside)
          
          navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: composeButton), UIBarButtonItem(customView: searchButton)]
        }
        
        @objc func composeOnClick(_ sender : UIBarButtonItem)
        {
    //       let alert = UIAlertController(title: "ttest", message: "hello world", preferredStyle: .actionSheet)
    //       self.present(alert, animated: true, completion: nil)
            self.collectionView.reloadData()
        }
        
        
        private func setupLeftButton()
        {
            let followButton = UIButton(type: .system)
            followButton.setImage(#imageLiteral(resourceName: "test").withRenderingMode(.alwaysOriginal), for: .normal)
            followButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            followButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
            followButton.imageView?.contentMode = .scaleAspectFit
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: followButton)
        }
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return managerData.getLength()
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
            cell.userModel = self.data[indexPath.item]
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
                          label.text = "Who to Follow"
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
