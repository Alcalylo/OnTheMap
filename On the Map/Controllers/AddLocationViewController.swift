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
        self.hideKeyboardWhenTappedAround() 
        location.delegate = self
        link.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    
}
    
    

