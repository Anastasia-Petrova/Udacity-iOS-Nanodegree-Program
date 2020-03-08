//
//  MemeStore.swift
//  Meme
//
//  Created by Anastasia Petrova on 27/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

enum MemeStore {
    private static let memesKey = "memes"
    
    public static func save(memes: [Meme]) throws {
        do {
            let encodedData = try JSONEncoder().encode(memes)
            UserDefaults.standard.set(encodedData, forKey: memesKey)
        } catch {
            throw Error.encodingFailed
        }
    }
    
    public static func loadMemes() -> [Meme] {
        guard let encodedData = UserDefaults.standard.data(forKey: memesKey) else {
            return []
        }
        do {
            return try JSONDecoder().decode([Meme].self, from: encodedData)
        } catch {
            UserDefaults.standard.removeObject(forKey: memesKey)
            return []
        }
    }
    
    public static func deleteMeme(id: UUID) {
        let allButOne = MemeStore
            .loadMemes()
            .filter { $0.id != id }
            
        if let encodedData = try? JSONEncoder().encode(allButOne) {
            UserDefaults.standard.set(encodedData, forKey: "memes")
        }
    }
}

extension MemeStore {
    enum `Error`: Swift.Error {
        case encodingFailed
    }
}
