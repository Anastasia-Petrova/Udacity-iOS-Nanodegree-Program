//
//  PinViewModel.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 07/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import EasyCoreData
import MapKit

struct PinViewModel: CoreDataMappable {
    let latitude: Double
    let longitude: Double
    let photoURLs: [URL]
    
    init(model: Pin) {
        latitude = model.latitude
        longitude = model.longitude
        if let photos = model.photos as? Set<Photo> {
            photoURLs = photos.compactMap { $0.url }
        } else {
            photoURLs = []
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
