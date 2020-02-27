//
//  MemesStorage.swift
//  Meme
//
//  Created by Anastasia Petrova on 27/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

enum MemesStorage {
    public static func decodeData() -> [MemeModel] {
        guard let encodedData = UserDefaults.standard.data(forKey: "memes") else {
            return []
        }
        return try! JSONDecoder().decode([MemeModel].self, from: encodedData)
    }
    
    public static func encodeData(memes: [MemeModel]) {
        let encodedData = try! JSONEncoder().encode(memes)
        UserDefaults.standard.set(encodedData, forKey: "memes")
    }
    
    public static func getAllIMages(memes: [MemeModel]) -> [(text: String, image: UIImage)] {
        let sortedMemes = memes.sorted(by: { $1.date > $0.date })
        var textAndImagesArray: [(String, UIImage)] = []
        sortedMemes.forEach { meme in
            let text = meme.topTetx + "..." + meme.bottomText
            let directoryURL = ImageStorage.memesDirectory.appendingPathComponent(meme.id.uuidString)
            if let image = UIImage(contentsOfFile: directoryURL.path) {
                textAndImagesArray.append((text, image))
            }
        }
        return textAndImagesArray
    }
    
    public func getAllTextsAndImages(memes: [MemeModel]) -> [(text: String, image: UIImage)] {
        let sortedMemes = memes.sorted(by: { $1.date > $0.date })
        var textAndImagesArray: [(String, UIImage)] = []
        sortedMemes.forEach { meme in
            let text = meme.topTetx + "..." + meme.bottomText
            let directoryURL = ImageStorage.memesDirectory.appendingPathComponent(meme.id.uuidString)
            if let image = UIImage(contentsOfFile: directoryURL.path) {
                textAndImagesArray.append((text, image))
            }
        }
        return textAndImagesArray
    }
    
    public func deleteMeme(memes: [MemeModel], indexPath: IndexPath) -> [MemeModel]{
        let item = memes[indexPath.row]
        let id = item.id
        let directoryURL = ImageStorage.memesDirectory.appendingPathComponent(id.uuidString)
        try? ImageStorage.deleteImage(url: directoryURL)
        var array = memes
        array.remove(at: indexPath.row)
        let encodedData = try! JSONEncoder().encode(memes)
        UserDefaults.standard.set(encodedData, forKey: "memes")
        return array
    }
}
