//
//  UserStorage.swift
//  Meme
//
//  Created by Anastasia Petrova on 25/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit

enum ImageStorage {
    public static let memesDirectory: URL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("memeImages")
    
    public static func saveImage(image: UIImage, id: UUID) throws {
        if !FileManager.default.fileExists(atPath: Self.memesDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: Self.memesDirectory, withIntermediateDirectories: true, attributes: nil)
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
    }
    
    static func deleteImage(id: UUID) throws -> Void {
        let fileManager = FileManager.default
        let url = ImageStorage.memesDirectory.appendingPathComponent(id.uuidString)
        try? fileManager.removeItem(at: url)
    }
    
    static func getImage(id: UUID) -> UIImage? {
        let url = ImageStorage.memesDirectory.appendingPathComponent(id.uuidString)
        return UIImage(contentsOfFile: url.path)
    }
    
    static func getAllImageURLs() throws -> [URL] {
        let fileManager = FileManager.default
        let directoryContents = try fileManager.contentsOfDirectory(at: Self.memesDirectory, includingPropertiesForKeys: nil)
        return directoryContents
    }

    static func deleteAllImages() throws -> Void {
        try? FileManager.default.removeItem(at: Self.memesDirectory)
    }
}
