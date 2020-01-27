//
//  SignUpViewController.swift
//  Rezozio
//
//  Created by eldin smakic on 24/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var bird1: UIImageView!
    @IBOutlet weak var bird2: UIImageView!
    @IBOutlet weak var bird3: UIImageView!
    @IBOutlet weak var bird4: UIImageView!
    
    private var firestore: Firestore!
    private var manageData : ManageData!
    private var navControler : UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRoundedCornerToButton()
//        addRoundedCornerToTextView()
//        addPrefixMailAndPassword()
        self.firestore = Firestore.firestore()
        self.manageData =  ManageData()
        self.animAllBirds()
        self.animShakeSignUp()
        
        // Do any additional setup after loading the view.
    }
    
    /**
             Make the SignUp button shake
     */
    func animShakeSignUp()
    {
        UIView.animate(withDuration: 0.2, delay: 15, options: [.repeat, .autoreverse] , animations: {
            self.signUpButton.layer.position.x += 2
        }, completion: nil)
    }
    
    /***
     Make all birds animate from left to right
     flying and disappear */
    func animAllBirds()
    {
        self.animBird(bird:self.bird1)
        self.animBird(bird:self.bird2, delay : 0.5)
        self.animBird(bird:self.bird3, delay : 1.0)
        self.animBird(bird:self.bird4, delay : 1.5)
        
    }
    
    
     ///   Make a bird Bird animate from left to right
     ///   flying and disappear
         
    ///    - parameter bird: bird to animate
    ///    - parameter delay : delay to make animation start after a certain time (by default = 0)
    func animBird(bird: UIImageView, delay : TimeInterval = 0 )
    {
         UIView.animate(withDuration: 2.0 ,delay: delay , animations: {
            bird.layer.position.x += self.view.bounds.width + bird.bounds.width
               },completion: { (Bool) in
                bird.layer.position.x = 0 - bird.bounds.width
                UIView.animate(withDuration: 3.0 , delay: 0, options: [.repeat], animations: {
                    bird.layer.position.x += self.view.bounds.width + (bird.bounds.width * 2)
            }, completion: nil)
        })
    }
    
    /*
        OnClick on SignUp Button, check if
        email and password are valid and try to create new user with firebase
     */
    @IBAction func OnSignOn(_ sender: UIButton)
    {
        var pass : Bool = true
        if (isPasswordValid() == false)
        {
           
                print("Bad password !")
                pass = false
           
        }
         if ( isEmailValid()  == false)
        {
                print("Bad Email")
                pass = false
        }
        if (pass)
        {
            let pw = passwordTextField.text!
            let email = emailTextField.text!
            let user  = usernameTextField.text!
            Auth.auth().createUser(withEmail: email, password: pw, completion:
           {
               (authResult,error) in
               if (error != nil)
               {
                   print(error.debugDescription)
               }
               else
               {
                 if (self.manageData.addUserToDataBase(user: user, email: email))
                 {
                    print("Succes")
                 }
                     
               }

            })
        }
         
    }
    
    
    @IBAction func OnClickLogin(_ sender: UIButton) {
               var pass : Bool = true
               if (isPasswordValid() == false)
               {
                  
                       print("Bad password !")
                       pass = false
                  
               }
                if ( isEmailValid()  == false)
               {
                       print("Bad Email")
                       pass = false
               }
                if (pass)
                {
                    let pw = passwordTextField.text!
                    let email = emailTextField.text!
                    Auth.auth().signIn(withEmail: email, password: pw, completion:
                   {
                       (auth,error) in
                       if (error != nil)
                       {
                           print( error.debugDescription)
                       }
                       else
                       {
                        let mainVC = MainViewController( collectionViewLayout : UICollectionViewFlowLayout())
                        self.navigationController?.pushViewController(mainVC, animated: true)
                       }
                   })
            }
               
    }
    
    
    
    
    /**
                    Test if password has a length of 6
     */
    private func isPasswordValid() -> Bool
    {
        return stringMatchesPattern(string: passwordTextField.text!, pattern: "^.{6}")
    }
    
    /**
                        Test if a string matche a pattern
     */
    private func stringMatchesPattern(string: String, pattern : String) -> Bool
    {
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return regex?.firstMatch(in: string , options: [], range: NSRange(location: 0, length: string.count)) != nil
    }
    
    
    /**
                Test if email have a good email pattern
     */
    private func isEmailValid() -> Bool
    {
        return stringMatchesPattern(string: emailTextField.text!, pattern: "^[a-z0-9]+@[a-z0-9]+[.][a-z]+$")
    }
    
    private func addRoundedCornerToTextView()
    {
        usernameTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        emailTextField.layer.cornerRadius = 20
    }
    
    
    private func addPrefixMailAndPassword()
    {
        passwordTextField.text = "testtest"
        emailTextField.text = "test@test1.fr"
    }
    
    
    private func addRoundedCornerToButton()
    {
        signUpButton.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 20
    }

}
