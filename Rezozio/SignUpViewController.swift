//
//  SignUpViewController.swift
//  Rezozio
//
//  Created by eldin smakic on 24/12/2019.
//  Copyright © 2019 eldin smakic. All rights reserved.
//

import UIKit


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
