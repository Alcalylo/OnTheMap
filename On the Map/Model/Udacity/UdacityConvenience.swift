//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by ALCALY LO on 3/7/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    func authentication (_ viewController : UIViewController, _ username : String, _ password : String, completionHandlerforAuth : @escaping (_ success : Bool, _ result : AnyObject, _ error : String?) ->Void) {
        
        _ = taskforPOSTmethod(username, password) { (result, error) in
            
            performUIUpdatesOnMain {
                
                if (error != nil) {
                    completionHandlerforAuth(false, result!, error!)
                }
                else
                {
                    if  let account = result!["account"] as? [String : AnyObject], let key = account["key"] as? String {
                        Constants.StudentInformation.uniqueKey = key
                        print(Constants.StudentInformation.uniqueKey)
                        completionHandlerforAuth(true, result!, nil)
                    }
                }
            }
        }
    }
 
    
    func logOutFunction (completionHandlerForLogOut : @escaping ( _ response : AnyObject, _ error : String?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                completionHandlerForLogOut("NULL" as AnyObject, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            completionHandlerForLogOut(newData as AnyObject,nil)
            
        }
        
        task.resume()
    }
    
    
    func getPublicData(_ uniqueID: String, completionHandlerForGetPublicData : @escaping (_ success : Bool, _ result : String, _ error : String?) -> Void)
    {
        taskForGETMethodUdacity(uniqueID) { (result, error) in
            performUIUpdatesOnMain {
                if error != nil
                {
                    print("Error getting public data")
                    //    completionHandlerForGetPublicData(false,result! as! String,error)
                }
                else
                {
                    if let user = result!["user"] as! [String:AnyObject]?
                    {
                        performUIUpdatesOnMain {
                            if let lastName = user["last_name"] as! String?
                            {
                                userInformation.lastName = lastName
                            }
                            
                            if let firstName = user["first_name"] as! String?
                            {
                                userInformation.firstName = firstName
                            }
                        }
                    }
                }
                
            }
            
        }
    }
}
