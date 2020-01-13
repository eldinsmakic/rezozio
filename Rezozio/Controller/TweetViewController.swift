//
//  TweetViewController.swift
//  Rezozio
//
//  Created by eldin smakic on 02/01/2020.
//  Copyright © 2020 eldin smakic. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import AwaitKit
import PromiseKit

class TweetViewController: UIViewController, UITextFieldDelegate {
    
    private var db : Firestore
    private var manageData : ManageData
    private var data : UserModel?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        self.addTextField()
        // Do any additional setup after loading the view.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.db = Firestore.firestore()
        self.data = nil
        self.manageData = ManageData()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addTextField()
    {
        let textField = UITextField()
        textField.placeholder = "Write it"
        textField.translatesAutoresizingMaskIntoConstraints =  false
        textField.returnKeyType = .send
        view.addSubview(textField)
        textField.widthAnchor.constraint(equalTo:  view.widthAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: view.bounds.height/2 ).isActive = true
        textField.becomeFirstResponder()
        textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let text = textField.text!
        self.sendTweet(text: text )
        return true
    }
    
    func sendTweet(text: String)
    {
        async {
            let user : UserModel = try! await(self.manageData.getUserInfoAsync())
            let data = TweetFactory.factory.createDataForNewTweet(text: text, user: user)
            let result = try! await(self.manageData.AddTweet(data: data))
            if ( result == true)
            {
                self.manageData.addTweetToUser(tweetUID: result)
                print("tweet send")
            }
            else
            {
                print("Eroor Tweet")
            }
        }
    }
}
