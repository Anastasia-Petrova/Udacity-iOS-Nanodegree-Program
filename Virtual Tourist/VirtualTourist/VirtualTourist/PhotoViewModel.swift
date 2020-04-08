//
//  PhotoViewModel.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 07/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//
import Foundation
import EasyCoreData

struct PhotoViewModel: CoreDataMappable {
    let url: URL?
    let fileID: UUID?
    
    init(model: Photo) {
        fileID = model.fileID
        url = model.url
    }
}
