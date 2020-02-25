//
//  UserStorage.swift
//  Meme
//
//  Created by Anastasia Petrova on 25/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit

class UserStorage {
    public static let memesDirectory: URL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("memeImages")
    
    public func saveImage(image: UIImage, id: UUID) -> URL {
        if !FileManager.default.fileExists(atPath: Self.memesDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: Self.memesDirectory, withIntermediateDirectories: true, attributes: nil)
                print("created directory at url: \(Self.memesDirectory)")
            } catch {
                print(error)
            }
        }
        
        let fileURL = Self.memesDirectory.appendingPathComponent(id.uuidString)
        do {
            try image.pngData()?.write(to: fileURL, options: .atomic)
            print("image saved to url: \(fileURL)")

        } catch {
            print(error)
        }
        let finalPath = fileURL
            .pathComponents
            .dropFirst(fileURL.pathComponents.count - 2)
            .reduce("") { $0 + "/" + $1 }
        
        return URL(string: finalPath)!
    }
    
    func deleteImage(url: URL) -> Void {
        let fileManager = FileManager.default
        try! fileManager.removeItem(at: url)
    }
    
    func getAllImages() -> [UIImage?] {
        var images: [UIImage] = []
        
        let fileManager = FileManager.default
        let directoryContents = try? fileManager.contentsOfDirectory(at: Self.memesDirectory, includingPropertiesForKeys: nil)
        guard let directoryContent = directoryContents else { return [] }
        for imageURL in directoryContent {
            if let image = UIImage(contentsOfFile: imageURL.path) {
                images.append(image)
            } else {
               fatalError("Can't create image from file \(imageURL)")
            }
        }
        return images
    }

    func deleteAllImages() -> Void {
        let memesFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("memeImages")
        let fileManager = FileManager.default
        try! fileManager.removeItem(at: memesFolderURL)
    }
}
