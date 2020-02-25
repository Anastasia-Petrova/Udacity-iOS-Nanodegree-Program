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
    public func saveImage(image: UIImage) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("memeImages")
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                print("created directory at url: \(directoryURL)")
            } catch {
                print(error)
            }
        }
        
        let fileURL = directoryURL.appendingPathComponent("memeImage")
        do {
            try image.pngData()?.write(to: fileURL, options: .atomic)
            print("image saved to url: \(fileURL)")

        } catch {
            print(error)
        }
    }
    
    func deleteImage(url: URL) -> Void {
        
    }
    
    func getAllImages() -> [UIImage] {
        var images: [UIImage] = []
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("memeImages")
        let fileManager = FileManager.default
        let directoryContents = try! fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
        for imageURL in directoryContents {
            if let image = UIImage(contentsOfFile: imageURL.path) {
                images.append(image)
            } else {
               fatalError("Can't create image from file \(imageURL)")
            }
        }
        return images
    }

    func deleteAllImages() -> Void {
        
    }
}
