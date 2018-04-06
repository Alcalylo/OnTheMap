//
//  ParseClient.swift
//  On the Map
//
//  Created by ALCALY LO on 3/7/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import Foundation

class ParseClient
{
    let session = URLSession.shared
    
    
    func taskForGETMethod(parameters: [String : AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        /* Build the URL, Configure the request */
        var request = URLRequest(url: OTMURLFromParameters(parameters))
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        print(request.url as Any)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
            
            /* Parse the data and use the data */
            self.convertDataWithCompletionHandler(data, completionHandlerforConvertData: completionHandlerForGET)
        }
        
        /* Start the request */
        task.resume()
        
    }
    
    private func OTMURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "parse.udacity.com"
        components.path = "/parse/classes/StudentLocation"
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print(components.url!)
        return components.url!
    }
    
    
    func convertDataWithCompletionHandler(_ data : Data, completionHandlerforConvertData : (_ result : AnyObject?, _ error : NSError?) -> Void )
    {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userinfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerforConvertData( nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userinfo))
        }
        
        completionHandlerforConvertData(parsedResult, nil)
    }
    
    
    func taskForPUTMethod(_ httpBody : String, _ objectID : String, completionHandlerForPut : @escaping( _ response: AnyObject?, _ error: Error?) -> Void) -> URLSessionTask
    {
        var urlString  = "https://parse.udacity.com/parse/classes/StudentLocation/\(objectID)"
        
        print(urlString)
        
        let url = URL(string : urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody.data(using: .utf8)
        
        let session = URLSession.shared
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            print(String (data : data!, encoding : .utf8) as Any)
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPut(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
            
            /* Parse the data and use the data */
            self.convertDataWithCompletionHandler(data,completionHandlerforConvertData: completionHandlerForPut)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    
    func taskForPOSTMethod(_ httpBody : String, completionHandlerForPost : @escaping (_ response : AnyObject?, _ error : Error?) -> Void)
    {
        var urlString  = "https://parse.udacity.com/parse/classes/StudentLocation"
        
        let url = URL( string : urlString)
        var request  = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            print(String (data : data!, encoding : .utf8) as Any)
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPost(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
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
            
            /* Parse the data and use the data */
            self.convertDataWithCompletionHandler(data, completionHandlerforConvertData : completionHandlerForPost)
        }
        
        /* Start the request */
        task.resume()
    }
    
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
