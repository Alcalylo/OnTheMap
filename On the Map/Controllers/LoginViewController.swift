//
//  ViewController.swift
//  On the Map
//
//  Created by ALCALY LO on 2/22/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextView: UITextView!
    
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginTextView.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.text = ""
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func udacityLogin() {
        
        guard let userEmail = emailTextField.text, !userEmail.isEmpty
            else {
            loginTextView.text = "Please Enter a valid Email!"
            return
        }
        
        guard let userPassword = passwordTextField.text, !userPassword.isEmpty
            else {
            loginTextView.text = "Please Enter a valid Password!"
            return
        }
        
        UdacityClient.sharedInstance().authentication(self, userEmail, userPassword) {(success, data, error) in
            
            if success == false {
                
                performUIUpdatesOnMain {
                    
                    self.loginTextView.text = "Please enter valid Email and Password"
                }
            }
            else {
                performUIUpdatesOnMain {
                     self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                }
            }
        }
    }
    
    
    @IBAction func udacitySignup(_ sender: Any) {
        
    UIApplication.shared.open(URL(string:"https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
   
}

