//
//  MemesStorage.swift
//  Meme
//
//  Created by Anastasia Petrova on 27/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

enum MemeStore {
    enum `Error`: Swift.Error {
        case encodingFailed
    }
    private static let defaults = UserDefaults.standard
    private static let key = "memes"
    
    public static func save(memes: [MemeModel]) throws {
        do {
            let encodedData = try JSONEncoder().encode(memes)
            UserDefaults.standard.set(encodedData, forKey: MemeStore.key)
        } catch {
            throw Error.encodingFailed
        }
    }
    
    public static func loadMemes() -> [MemeModel] {
        guard let encodedData = UserDefaults.standard.data(forKey: MemeStore.key) else {
            return []
        }
        do {
            return try JSONDecoder().decode([MemeModel].self, from: encodedData)
        } catch {
            UserDefaults.standard.removeObject(forKey: MemeStore.key)
            return []
        }
    }
    
    public static func delete(memes: [MemeModel], indexPath: IndexPath) -> [MemeModel] {
        var array = memes
        array.remove(at: indexPath.row)
        let encodedData = try! JSONEncoder().encode(memes)
        UserDefaults.standard.set(encodedData, forKey: MemeStore.key)
        return array
    }
}
