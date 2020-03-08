//
//  Meme.swift
//  Meme
//
//  Created by Anastasia Petrova on 18/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

struct Meme: Codable {
    let id: UUID
    var topText: String
    var bottomText: String
    let date: Date
}
