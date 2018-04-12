//
//  UserInformation.swift
//  On the Map
//
//  Created by ALCALY LO on 3/7/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import Foundation

var userInformation = StudentData(dictionary: [:])

class SharedData {
    static let sharedInstance = SharedData()
    var StudentLocations = [StudentData]()
    private init() {}
    }
