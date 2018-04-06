//
//  MapViewController.swift
//  On the Map
//
//  Created by ALCALY LO on 3/7/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // Mark: Outlets
    
    @IBOutlet var map: MKMapView!
    
    // Mark: Variables
    
    var refresh = 0
    var annotations = [MKPointAnnotation]()
    
    // Mark: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        callstudentInformation()
        ParseClient.sharedInstance().getStudentInformation({ (success, result, error) in
            
            if success == false {
                print("Issue retrieving User Information")
            }
            else
            {
                print(result as Any)
                UdacityClient.sharedInstance().getPublicData((userInformation.uniqueKey!)) { (success, result, error) in
                    debugPrint ("callsuccess")
                }
            }
        })
    }
    
    
    func callstudentInformation() {
        ParseClient.sharedInstance().getStudentsInformation({(success, data, error) in
            
            if(error != nil)
            {
                print ("Error loading student data")
            }
                
            else
            {
                let  studentsArray = data!["results"] as? [[String : AnyObject]]
                
                for student in studentsArray!
                {
                    SharedData.sharedInstance.StudentLocations.append(studentInformation(dictionary: student))
                }
                
                if studentsArray?.count != 0
                {
                    self.markPins(SharedData.sharedInstance.StudentLocations, 0)
                }
            }
        })
    }
    
    func markPins(_ studentinfo : [studentInformation], _ refresh : Int)
    {
        performUIUpdatesOnMain {
            if(refresh == 1)
            {
                let annotationRefresh = self.map.annotations
                
                for i in annotationRefresh {
                    self.map.removeAnnotation(i)
                }
                
                print ("annotations removed after refresh")
            }
        }
        
        for student in studentinfo
        {
            if let latitude = student.latitude,
                let longitude = student.longitude {
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                let coordinate =   CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                if let firstName = student.firstName,
                    let lastName = student.lastName
                {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(String(describing: firstName))" + " " + "\(String(describing: lastName))"
                    annotation.subtitle = student.mediaURL
                    
                    annotations.append(annotation)
                    
                }
            }
        }
        
        
        performUIUpdatesOnMain {
            self.map.addAnnotations(self.annotations)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
        else
        {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            if let toOpen = view.annotation?.subtitle! {
                let url = URL(string : toOpen)
                UIApplication.shared.open(url!)
            }
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
        performUIUpdatesOnMain {
            if userInformation.objectID == nil {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
                self.present(controller, animated: true, completion: nil)
            }
                
            else
            {
                    self.displayAlert("User \(String(describing: userInformation.firstName)))) \(String(describing:  userInformation.lastName))) has already posted a location. Would you like to Overwrite their location?")
                
            }
        }
    }
    
    @IBAction func refresh(_ sender : Any)
    {
        ParseClient.sharedInstance().getStudentsInformation({(success, data, error) in
            
            if error != nil
            {
                print ("Error loading student data")
            }
                
            else
            {
                let  studentsArray = data!["results"]  as? [[String : AnyObject]]
                
                for student in studentsArray!
                {
                    SharedData.sharedInstance.StudentLocations.append(studentInformation(dictionary : student))
                }
                
                if studentsArray?.count != 0
                {
                    self.markPins(SharedData.sharedInstance.StudentLocations, 1)
                }
            }
        })
    }
    
    
    func displayAlert( _ message : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            self.present(controller, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
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
                    
                else {
                    print("Log off successful")
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(controller!, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    
}


