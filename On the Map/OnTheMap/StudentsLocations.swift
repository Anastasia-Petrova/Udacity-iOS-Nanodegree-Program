//
//  StudentsLocations .swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 23/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

struct Locations: Codable {
    let locations: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case locations = "results"
    }
}

struct StudentLocation: Codable {
    let creationDate: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longlatitude: Float
    let location: String
    let link: String
    let objectID: String
    let uniqueKey: String
    let updateDate: String
    
    enum CodingKeys: String, CodingKey {
        case creationDate = "createdAt"
        case firstName = "firstName"
        case lastName = "lastName"
        case latitude = "latitude"
        case longlatitude = "longitude"
        case location = "mapString"
        case link = "mediaURL"
        case objectID = "objectId"
        case uniqueKey = "uniqueKey"
        case updateDate = "updatedAt"
    }
}
