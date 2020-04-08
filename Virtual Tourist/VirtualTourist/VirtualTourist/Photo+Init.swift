//
//  Photo+Init.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 07/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import CoreData

extension Photo {
    convenience init() {
        self.init(entity: Photo.entity(),
                  insertInto: nil)
    }
}
