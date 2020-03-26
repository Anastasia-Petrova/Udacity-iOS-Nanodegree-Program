//
//  LocationRequest.swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 26/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

struct LocationRequest: Encodable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
