//
//  StudentsLocations .swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 23/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

struct Locations: Codable, Equatable {
    static func == (lhs: Locations, rhs: Locations) -> Bool {
        return lhs.locations == rhs.locations
    }
    
    let locations: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case locations = "results"
    }
}

struct StudentLocation: Codable, Equatable {
    let creationDate: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
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
        case longitude = "longitude"
        case location = "mapString"
        case link = "mediaURL"
        case objectID = "objectId"
        case uniqueKey = "uniqueKey"
        case updateDate = "updatedAt"
    }
}
