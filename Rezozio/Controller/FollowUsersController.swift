//
//  FollowUsersController.swift
//  Rezozio
//
//  Created by eldin smakic on 31/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//

import UIKit
import AwaitKit
import PromiseKit

class FollowUsersController: UICollectionViewController , UICollectionViewDelegateFlowLayout {

    private let  headerId = "headerId"
    private let  footerId = "footerId"
    private var managerData : ManageData
    var data : [UserModel]

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        self.managerData = ManageData()
        self.data = []
        super.init(collectionViewLayout: layout)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()

        self.setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fetchUsers()
    }

    func setupLayout() {
        self.setupCells()
        self.setupNavigationBar()
        collectionView.backgroundColor = .white
        view.addSubview(composeButton)
//        collectionView.bringSubviewToFront(composeButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            composeButton.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant: -16),
            composeButton.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -16)
        ])
    }

     func fetchUsers()
     {
        async{
            let data = try! await(self.managerData.getUsers())
            self.data = data
            for data in self.data
            {
                let image = try! await(self.managerData.getUserProfilePhotoWithUrl(user_url:  data.getImageLink()))
                data.setImage(image: image)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
      }

     func setupCells()
    {
        collectionView.register( UserCell.self , forCellWithReuseIdentifier: UserCell.reuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
    }
        
    func setupNavigationBar()
    {
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
        searchButton.setImage(UIImage(systemName: "magnifyingglass")!.withRenderingMode(.alwaysOriginal), for: .normal)
      searchButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
      searchButton.imageView?.contentMode = .scaleAspectFit
      searchButton.widthAnchor.constraint(equalToConstant: 35).isActive = true

      navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: searchButton)]
    }
        
    @objc func composeOnClick(_ sender : UIBarButtonItem)
    {
//       let alert = UIAlertController(title: "ttest", message: "hello world", preferredStyle: .actionSheet)
//       self.present(alert, animated: true, completion: nil)
        self.collectionView.reloadData()
    }

    var composeButton: UIButton =  {
        let button = UIButton()
        let image = UIImage(systemName: "plus.circle.fill")!
        button.backgroundColor = .blue
        button.setImage(image, for: .normal)
        button.layer.zPosition = .infinity
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])

        return button
    }()
        
    @objc func followButtonOnClick(_  sender : UIButton)
    {
        let cell = sender.superview?.superview as! UserCell
        let user = cell.userModel!
        cell.changeTitleFollowButton()
        self.managerData.changeUserFollows(uid: user.getUID() )

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
        cell.userModel = self.data[indexPath.item]
        cell.followButton.addTarget(self, action: #selector(followButtonOnClick), for: .touchUpInside)
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
