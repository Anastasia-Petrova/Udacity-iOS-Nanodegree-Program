//
//  FlickrPhotoRequest.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 05/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

struct FlickrPhotoRequest: Codable {
    let id: String
    let farm: Int
    let server: String
    let secret: String
}
