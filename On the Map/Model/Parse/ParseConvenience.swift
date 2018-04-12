//
//  ParseConvenience.swift
//  On the Map
//
//  Created by ALCALY LO on 3/7/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import Foundation
import MapKit

extension ParseClient
{
    // GETting studentlocations
    func getStudentsInformation(_ completionHandlerForGetStudentsInfo : @ escaping (_ success : Bool, _ result : AnyObject?, _ errorString : String?) ->  Void)
    {
        /* Set the parameters */
        let parameters = ["limit" : 100, "order" : "-updatedAt"] as [String : AnyObject]
        
        /* Build the URL and Configure the request */
        taskForGETMethod(parameters: parameters) { (result, error) in
            if let error = error {
                print(error)
                completionHandlerForGetStudentsInfo(false, nil, "Failed to GET student information")
            }
            else
            {
                completionHandlerForGetStudentsInfo(true, result, nil)
            }
        }
    }
    
    //GETting a student location
    
    func getStudentInformation(_ completionHandlerForGetStudentInfo : @ escaping (_ success : Bool , _ result : AnyObject?, _ errorString : String?) -> Void )
    {
        let parameters = ["where" : "{\"uniqueKey\":\"\(Constants.StudentInformation.uniqueKey)\"}"]
        taskForGETMethod(parameters: parameters as [String : AnyObject]) { (result, error) in
            if let error = error {
                print(error)
                completionHandlerForGetStudentInfo(false, nil, "Failed to GET student information")
            }
            else
            {
                var userLocation : StudentData
                var results = result!["results"]  as? [[String : AnyObject]]
                
                print(results?.count as Any)
                
                if(results?.count != 0 )
                {
                    userLocation = StudentData(dictionary: (results![0]))
                    userInformation  = userLocation
                    
                    print(userInformation.firstName as Any)
                    print(userInformation.lastName as Any)
                    print(userInformation.latitude as Any)
                    print(userInformation.longitude as Any)
                    print(userInformation.mapString as Any)
                    print(userInformation.mediaURL as Any)
                    print(userInformation.objectID as Any)
                    
                }
                else
                {
                    UdacityClient.sharedInstance().getPublicData(Constants.StudentInformation.uniqueKey) { (success, result, error) in
                        print("callpublicdata")
                    }
                }
            }
            
        }
    }
    
    
    func putStudentInformation( _ completionHandlerForPut : @ escaping(_ success : Bool , _ error : Error?) -> Void)
    {
        let httpBody = "{\"uniqueKey\":\"\(Constants.StudentInformation.uniqueKey)\", \"firstName\": \"\(userInformation.firstName!)\", \"lastName\": \"\(userInformation.lastName!)\",\"mapString\": \"\(userInformation.mapString!)\", \"mediaURL\": \"\(userInformation.mediaURL!)\",\"latitude\": \(userInformation.latitude!), \"longitude\": \(userInformation.longitude!)}"
        print(httpBody)
        
        _ = taskForPUTMethod(httpBody,userInformation.objectID!) {(success,error) in
            if let error = error
            {
                completionHandlerForPut(false,error)
            }
            else
            {
                completionHandlerForPut(true,nil)
            }
            
        }
    }
    
    
    func postStudentInformation(_ completionHandlerForPost : @escaping (_ success : Bool ,_ result : AnyObject?, _ error : Error?) ->Void)
    {
        print(Constants.StudentInformation.uniqueKey)
        print(userInformation.firstName as Any)
        print(userInformation.lastName as Any)
        print(userInformation.latitude as Any)
        print(userInformation.longitude as Any)
        print(userInformation.mapString as Any)
        print(userInformation.mediaURL as Any)
        
        let httpBody = "{\"uniqueKey\":\"\(Constants.StudentInformation.uniqueKey)\", \"firstName\": \"\(userInformation.firstName!)\", \"lastName\": \"\(userInformation.lastName!)\",\"mapString\": \"\(userInformation.mapString!)\", \"mediaURL\": \"\(userInformation.mediaURL!)\",\"latitude\": \(userInformation.latitude!), \"longitude\": \(userInformation.longitude!)}"
        taskForPOSTMethod(httpBody)
        {(result,error) in
            
            if let error = error{
                completionHandlerForPost(false,result,error)
            }
            else
            {
                completionHandlerForPost(true,result,nil)
            }
            
        }
    }
    
}





