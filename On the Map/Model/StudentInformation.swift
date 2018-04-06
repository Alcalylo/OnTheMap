//
//  StudentInformation.swift
//  On the Map
//
//  Created by ALCALY LO on 3/7/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import Foundation

struct studentInformation
{
    var firstName: String? = "First Name"
    var lastName: String? = "Last Name"
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    var mediaURL: String? = "Media URL"
    var objectID: String? = "ObjectID"
    var uniqueKey: String? = "Unique Key"
    var mapString: String? = "Map String"
    
    init(dictionary : [String : AnyObject])
    {
        firstName =  (dictionary["firstName"] as? String)
        lastName = (dictionary["lastName"] as? String)
        latitude = (dictionary["latitude"] as? Double)
        longitude = (dictionary["longitude"] as? Double)
        mediaURL = (dictionary["mediaURL"] as? String)
        objectID = (dictionary["objectId"] as? String)
        uniqueKey = (dictionary["uniqueKey"] as? String)
        mapString = (dictionary["mapString"] as? String)
        
        
    }
}
