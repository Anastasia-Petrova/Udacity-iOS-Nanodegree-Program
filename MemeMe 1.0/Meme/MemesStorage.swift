//
//  MemesStorage.swift
//  Meme
//
//  Created by Anastasia Petrova on 27/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

enum MemesStorage {
    private static let defaults = UserDefaults.standard
    
    public static func save(memes: [MemeModel]) throws {
        let encodedData = try JSONEncoder().encode(memes)
        UserDefaults.standard.set(encodedData, forKey: "memes")
    }
    
    public static func loadMemes() throws -> [MemeModel] {
        guard let encodedData = UserDefaults.standard.data(forKey: "memes") else {
            return []
        }
        return try JSONDecoder().decode([MemeModel].self, from: encodedData)
    }
    
    public static func delete(memes: [MemeModel], indexPath: IndexPath) -> [MemeModel] {
        var array = memes
        array.remove(at: indexPath.row)
        let encodedData = try! JSONEncoder().encode(memes)
        UserDefaults.standard.set(encodedData, forKey: "memes")
        return array
    }
}
