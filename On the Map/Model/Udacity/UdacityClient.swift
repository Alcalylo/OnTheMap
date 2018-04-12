//
//  UdacityClient.swift
//  On the Map
//
//  Created by ALCALY LO on 3/7/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient{
    
    func taskforPOSTmethod(_ username : String, _ password : String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                completionHandlerForPOST("NULL" as AnyObject, error)
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
            
            /* Parse the data and use the data */
            self.convertDataWithCompletionHandler(newData, completionHandlerforConvertData: completionHandlerForPOST)
        }
        
        /* Start the request */
        task.resume()
        
        return task
        
    }
    
    func taskForGETMethodUdacity(_ userid : String,completionHandlerForTaskForGetMethod : @escaping(_ results : AnyObject?,_ error : String?) ->Void)
    {
        let urlString = "https://www.udacity.com/api/users/\(userid)"
        let url = URL(string : urlString)
        let request =  URLRequest(url: url!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest){
            (data,response,error) in
            
            func sendError(_ error: String) {
                completionHandlerForTaskForGetMethod("NULL" as AnyObject, error)
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
            
            /* 5/6. Parse the data and use the data */
            self.convertDataWithCompletionHandler(newData, completionHandlerforConvertData: completionHandlerForTaskForGetMethod)
        }
        
        /* 7. Start the request */
        task.resume()
        
    }
    
    
    func convertDataWithCompletionHandler(_ data : Data, completionHandlerforConvertData : (_ result : AnyObject?, _ error : String?) -> Void )
    {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerforConvertData( nil, "Could not parse the data as JSON: '\(data)'")
        }
        
        completionHandlerforConvertData(parsedResult, nil)
        
    }
    
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
