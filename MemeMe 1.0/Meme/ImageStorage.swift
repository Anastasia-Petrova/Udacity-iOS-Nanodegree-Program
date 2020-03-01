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
    enum `Error`: Swift.Error {
        case imageNotFound
        
        var title: String {
            switch self {
            case .imageNotFound:
                return Labels.ImageStorage.Error.imageNotFoundTitle
            }
        }
        
        var localizedDescription: String {
            switch self {
            case .imageNotFound:
                return Labels.ImageStorage.Error.imageNotFoundDescription
            }
        }
    }
    
    public static let memesDirectory: URL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("memeImages")
    
    public static func saveImage(image: UIImage, id: UUID) throws {
        guard let imageData = image.pngData() else {
            throw ImageStorage.Error.imageNotFound
        }
        if !FileManager.default.fileExists(atPath: Self.memesDirectory.path) {
            try FileManager.default.createDirectory(
                at: Self.memesDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        let fileURL = Self.memesDirectory.appendingPathComponent(id.uuidString)
        try imageData.write(to: fileURL, options: .atomic)
    }
    
    static func deleteImage(id: UUID) throws -> Void {
        let url = ImageStorage.memesDirectory.appendingPathComponent(id.uuidString)
        try FileManager.default.removeItem(at: url)
    }
    
    static func getImage(id: UUID) -> UIImage? {
        let url = ImageStorage.memesDirectory.appendingPathComponent(id.uuidString)
        return UIImage(contentsOfFile: url.path)
    }
    
    static func getAllImageURLs() throws -> [URL] {
        let directoryContents = try FileManager.default.contentsOfDirectory(
            at: Self.memesDirectory,
            includingPropertiesForKeys: nil
        )
        return directoryContents
    }

    static func deleteAllImages() throws -> Void {
        try? FileManager.default.removeItem(at: Self.memesDirectory)
    }
}
