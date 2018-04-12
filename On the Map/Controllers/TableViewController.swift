//
//  TableViewController.swift
//  On the Map
//
//  Created by ALCALY LO on 3/8/18.
//  Copyright © 2018 ALCALY LO. All rights

import UIKit
import Foundation

class TableViewController: UITableViewController {
    
    // MARK: Properties
    var studentInfo: [StudentData] = []
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        self.displayTable()
    }
    
    func displayTable() {
        
        ParseClient.sharedInstance().getStudentsInformation({(success, data, error) in
            
            performUIUpdatesOnMain {
                if(error != nil)
                {
                    print ("Error loading student data")
                }
                else
                {
                    let  studentsArray = data!["results"]  as? [[String : AnyObject]]
                    
                    for student in studentsArray!
                    {
                        SharedData.sharedInstance.StudentLocations.append(StudentData(dictionary : student))
                    }
                    
                    if SharedData.sharedInstance.StudentLocations.count != 0
                    {
                        print("count")
                        print(SharedData.sharedInstance.StudentLocations.count)
                        performUIUpdatesOnMain {
                            
                            self.tableView?.reloadData()
                            
                        }
                        
                    }
                }
            }
        })
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedData.sharedInstance.StudentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        self.tableView.rowHeight = 60
        
        let info = SharedData.sharedInstance.StudentLocations[(indexPath as NSIndexPath).row]
        
        if let _ = info.firstName, let _ = info.lastName, let _ = info.mediaURL {
            
            cell.textLabel?.text = info.firstName! + " " + info.lastName!
            cell.imageView?.image = #imageLiteral(resourceName: "icon_pin-1")
            cell.detailTextLabel?.text = info.mediaURL
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = SharedData.sharedInstance.StudentLocations[(indexPath as NSIndexPath).row]
        
        let url = URL( string : info.mediaURL!)
        
        if url?.scheme != "https"
        {
            displayAlert(_message: "Invalid URL")
        }
        else
        {
            UIApplication.shared.open(url!)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func displayAlert(_message : String) {
        let alert = UIAlertController(title: title, message: _message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        self.present(controller, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender : Any)
    {
        displayTable()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        
        if userInformation.objectID == nil {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            self.tableView.reloadData()
            self.present(controller, animated: true, completion: nil)
            
        }
        else
        {
            displayAlert(_message: "User has already posted a location. Would you like to Overwrite their location?")
            
        }
        
    }
    
    @IBAction  func logOut(_ sender : Any)
    {
        performUIUpdatesOnMain {
            
            UdacityClient.sharedInstance().logOutFunction { (data, error) in
                if error != nil
                {
                    let alert = UIAlertController(title:"Log off Error", message: "Could not log out", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Log off Error", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        
                    }))
                }
                    
                else{
                    print("Log off successful")
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(controller!, animated: true, completion: nil)
                }
                
            }
        }
    }
    
}
