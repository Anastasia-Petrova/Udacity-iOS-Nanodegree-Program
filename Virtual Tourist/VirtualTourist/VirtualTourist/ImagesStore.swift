//
//  ImagesStore.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 08/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//


import Foundation
import UIKit

enum ImageStore {
    static let imagesDirectoryName = "virtualTouristImages"
    
    public static let imagesDirectoryURL: URL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent(imagesDirectoryName)
    
    public static func saveImage(image: UIImage) throws -> UUID {
        guard let imageData = image.pngData() else {
            throw ImageStore.Error.imageNotFound
        }
        if !FileManager.default.fileExists(atPath: imagesDirectoryURL.path) {
            try FileManager.default.createDirectory(
                at: imagesDirectoryURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        let id = UUID()
        let fileURL = imagesDirectoryURL.appendingPathComponent(id.uuidString)
        try imageData.write(to: fileURL, options: .atomic)
        return id
    }
    
    static func deleteImage(id: UUID) throws -> Void {
        let url = imagesDirectoryURL.appendingPathComponent(id.uuidString)
        try FileManager.default.removeItem(at: url)
    }
    
    static func getImage(id: UUID) -> UIImage? {
        let url = imagesDirectoryURL.appendingPathComponent(id.uuidString)
        return UIImage(contentsOfFile: url.path)
    }
}

extension ImageStore {
    enum `Error`: Swift.Error {
        case imageNotFound
        
        var title: String {
            switch self {
            case .imageNotFound:
                return "Image Not Found"
            }
        }
        
        var localizedDescription: String {
            switch self {
            case .imageNotFound:
                return "Looks like your image is empty. Try another one."
            }
        }
    }
}
