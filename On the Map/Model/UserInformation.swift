//
//  UserInformation.swift
//  On the Map
//
//  Created by ALCALY LO on 3/7/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import Foundation

var userInformation = studentInformation(dictionary: [:])

var exists: Bool = false

class SharedData {
    
    static let sharedInstance = SharedData()
    var StudentLocations = [studentInformation]()
    private init() {}
    
}
