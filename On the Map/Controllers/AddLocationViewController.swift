//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by ALCALY LO on 3/7/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var link: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.delegate = self
        link.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddLocationViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddLocationViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

         NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func findLocation (_ sender : Any)
    {
        let url = URL(string : link.text!)
        
        if url?.scheme != "https"
        {
            displayAlert("", "Please enter a valid link", "OK")
        }
        else if(!(link.text?.contains("://"))!)
            {
                displayAlert("", "Please enter a valid link", "OK")
            }
                
            else
            {
            Constants.StudentInformation.location = location.text!
            Constants.StudentInformation.url = link.text!
                
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "UpdateLocationViewController")
            self.present(controller!, animated: true, completion: nil)
        }
        
    }
    
    
    func displayAlert(_ title : String, _ message : String , _ action : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
 
    @IBAction func cancel (_ sender : Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification : NSNotification)
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        let keyboardYPosition = self.view.frame.height - keyboardHeight
        
        if (location.isFirstResponder && keyboardYPosition <  (location.frame.origin.y + location.frame.height)) {
            self.view.frame.origin.y = keyboardYPosition - (location.frame.origin.y + location.frame.height)
        }
        else if (link.isFirstResponder && keyboardYPosition <  (link.frame.origin.y + link.frame.height)) {
            self.view.frame.origin.y = keyboardYPosition - (link.frame.origin.y + link.frame.height)
        }
        
        
    }
    
    
    @objc func keyboardWillHide(notification : NSNotification)
    {
        self.view.frame.origin.y = 0
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
    
    

