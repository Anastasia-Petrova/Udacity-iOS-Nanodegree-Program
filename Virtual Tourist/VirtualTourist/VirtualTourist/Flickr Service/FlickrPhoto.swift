//
//  FlickrPhoto.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 05/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit

final class FlickrPhoto: Equatable {
    static func ==(lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        return lhs.id == rhs.id
    }
    var didLoadImage: ((String) -> Void)?
    
    var image: UIImage? {
        didSet {
            if image != nil {
                didLoadImage?(id)
            }
        }
    }
    
    let farm: Int
    let server: String
    let id: String
    let secret: String
    
    init (farm: Int, server: String,  id: String, secret: String) {
        self.farm = farm
        self.server = server
        self.id = id
        self.secret = secret
    }
    
    func flickrImageURL(_ size: String = "m") -> URL? {
        if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size).jpg") {
            return url
        }
        return nil
    }
    
    enum NetworkError: LocalizedError {
        case noData
        case invalidURL
        case taskError
        
        var errorDescription: String? {
            switch self {
            case .noData, .taskError: return "Something went wrong. Try again later."
            case .invalidURL : return "Invalid URL"
            }
        }
    }
    
    func loadImage(_ completion: @escaping (Error?) -> Void) {
        guard let loadURL = flickrImageURL() else {
            DispatchQueue.main.async {
                completion(NetworkError.invalidURL)
            }
            return
        }
        
        let loadRequest = URLRequest(url:loadURL)
        
        let task = URLSession.shared.dataTask(with: loadRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(NetworkError.noData)
                }
                return
            }
            
            let returnedImage = UIImage(data: data)
            self.image = returnedImage
            DispatchQueue.main.async {
                completion(nil)
            }
        }
        task.resume()
    }
}
