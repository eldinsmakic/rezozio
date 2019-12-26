//
//  SignUpViewController.swift
//  Rezozio
//
//  Created by eldin smakic on 24/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRoundedCornerToButton()
        addRoundedCornerToTextView()
        // Do any additional setup after loading the view.
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
            Auth.auth().createUser(withEmail: email, password: pw, completion:
                           {
                               (authResult,error) in
                               if (error != nil)
                               {
                                   print(error.debugDescription)
                               }
                               else
                               {
                                   print("succes")
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
                                               print("login success")
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
    
    
    private func addRoundedCornerToButton()
    {
        signUpButton.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 20
    }

}
