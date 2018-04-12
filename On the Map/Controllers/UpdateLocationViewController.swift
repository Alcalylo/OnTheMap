//
//  UpdateLocationViewController.swift
//  On the Map
//
//  Created by ALCALY LO on 3/13/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UpdateLocationViewController: UIViewController, MKMapViewDelegate {
    
    // Mark: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton : UIButton!
    
    // Mark: Properties
    
    let activityIndicator = UIActivityIndicatorView()
    
    let userLocation : String = Constants.StudentInformation.location
    var lat : CLLocationDegrees = 0.0
    var long : CLLocationDegrees = 0.0
    let link : String = ""
    let annotation = MKPointAnnotation()
    
    
    // MARK: LIFE CYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = userLocation
        displayActivityIndicator()
        activityIndicator.startAnimating()
        
        let searchLocation = MKLocalSearch(request: searchRequest)
        searchLocation.start(completionHandler: {(response, error) in performUIUpdatesOnMain {
            if error != nil {
                self.activityIndicator.stopAnimating()
                self.finishButton.isEnabled = false
                self.displayAlert("Location not Found", "Location not Found", "OK")
            }
            
            if let mapItems = response?.mapItems{
                if let mapLocation = mapItems.first{
                    self.annotation.coordinate = mapLocation.placemark.coordinate
                    self.lat = self.annotation.coordinate.latitude
                    self.long = self.annotation.coordinate.longitude
                    self.annotation.title = mapLocation.name
                    self.mapView.addAnnotation(self.annotation)
                    let region = MKCoordinateRegion(center: self.annotation.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
                    self.mapView.region = region
                    userInformation.mediaURL = Constants.StudentInformation.url
                    userInformation.latitude = self.annotation.coordinate.latitude
                    userInformation.longitude = self.annotation.coordinate.longitude
                    userInformation.mapString = mapLocation.name
                    
                }
                self.activityIndicator.stopAnimating()
            }
            }})
        
    }
    
    @IBAction func cancel (_ sender : Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func pressFinishButton(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        if userInformation.objectID == nil {
            performUIUpdatesOnMain {
                ParseClient.sharedInstance().postStudentInformation() {(success, result, error) in
                    self.activityIndicator.stopAnimating()
                    if(error !=  nil)
                    {
                        print("Error posting location")
                        self.displayAlert("Error", "Error Posting request", "Dismiss")
                    }
                    else
                    {
                        userInformation.objectID = (result?["objectId"] as? String)!
                        print(userInformation.objectID as Any)
                        debugPrint("Posted successfully")
                        //self.dismiss(animated: true, completion: nil)
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(controller!, animated: true, completion: nil)
                   //self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                
            }
            
        }
            
        else
        {
            performUIUpdatesOnMain {
                
                ParseClient.sharedInstance().putStudentInformation() { (success, error) in
                    if error !=  nil {
                        print("Error posting location")
                        self.displayAlert("Error", "Error Posting request", "Dismiss")
                    }
                        
                    else
                    {
                        performUIUpdatesOnMain {
                            
                            print("Posted(PUT) successfully")
                            let controller =
                              self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                            self.present(controller!, animated: true, completion: nil)
                           // self.dismiss(animated: true, completion: nil)
                       //self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    
                }
                
            }
            
            
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
    
    
    func displayAlert(_ title : String, _ message : String , _ action : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: {action in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
    }
    
}
