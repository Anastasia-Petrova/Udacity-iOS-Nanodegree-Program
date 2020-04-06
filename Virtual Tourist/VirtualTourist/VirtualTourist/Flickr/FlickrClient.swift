//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 04/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import UIKit

final class FlickrClient {
    static let flickrKey = "d11ec3e184321976fcf918e309ec868d"
    
    enum Endpoints {
        static let base = "https://api.flickr.com/services/rest/?method="
        
        case getPhotosForLocation(lat: String, lon: String, page: Int)
        
        var stringValue: String {
            switch self {
            case .getPhotosForLocation(let latitude, let longitude, let page):
                return Endpoints.base
                    + "flickr.photos.search"
                    + "&api_key=\(FlickrClient.flickrKey)"
                    + "&lat=\(latitude)&lon=\(longitude)"
                    + "&page=\(page)&per_page=15"
                    + "&format=json&nojsoncallback=1"
            }
        }
    }
    
    enum Error: Swift.Error {
        case unknownAPIResponse
        case generic
        case taskError
    }
    
    class func makegetPhotosRequest(latitude: String, longitude: String, page: Int) -> URLRequest {
         let url = URL(string: Endpoints.getPhotosForLocation(lat: latitude, lon: longitude, page: page).stringValue)!
        return URLRequest(url: url)
    }
    
    class func makegetPhotosTask(
        session: URLSession = .shared,
        request: URLRequest,
        completion: @escaping (Result<FlickrSearchResults, Error>) -> Void
    ) -> URLSessionDataTask {
        return session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(Result.failure(Error.taskError))
                }
                return
            }
            
            guard let _ = response as? HTTPURLResponse,
                let data = data else {
                    DispatchQueue.main.async { completion(Result.failure(Error.unknownAPIResponse))
                    }
                    return
            }
            
            do {
                guard
                    let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
                    let stat = resultsDictionary["stat"] as? String
                    else {
                        DispatchQueue.main.async {
                            completion(Result.failure(Error.unknownAPIResponse))
                        }
                        return
                }
                
                switch (stat) {
                case "ok":
                    print("Results processed OK")
                case "fail":
                    DispatchQueue.main.async {
                        completion(Result.failure(Error.generic))
                    }
                    return
                default:
                    DispatchQueue.main.async {
                        completion(Result.failure(Error.unknownAPIResponse))
                    }
                    return
                }
                
                guard
                    let photosContainer = resultsDictionary["photos"] as? [String: AnyObject],
                    let photosReceived = photosContainer["photo"] as? [[String: AnyObject]]
                    else {
                        DispatchQueue.main.async { completion(Result.failure(Error.unknownAPIResponse))
                        }
                        return
                }
                
                let flickrPhotos: [FlickrPhoto] = photosReceived.compactMap { photoObject in
                    guard
                        let id = photoObject["id"] as? String,
                        let farm = photoObject["farm"] as? Int ,
                        let server = photoObject["server"] as? String ,
                        let secret = photoObject["secret"] as? String
                        else {
                            return nil
                    }
                    let flickrPhoto = FlickrPhoto(
                        farm: farm,
                        server: server,
                        id: id,
                        secret: secret
                    )
                    
                    guard
                        let url = flickrPhoto.flickrImageURL(),
                        let imageData = try? Data(contentsOf: url as URL)
                        else {
                            return nil
                    }
                    if let image = UIImage(data: imageData) {
                        flickrPhoto.image = image
                        return flickrPhoto
                    } else {
                        return nil
                    }
                }
                let searchResults = FlickrSearchResults(searchResults: flickrPhotos)
                DispatchQueue.main.async {
                    completion(Result.success(searchResults))
                }
                
            } catch {
               print("\(error)")
            }
        }
    }
    
    class func getPhotos(
        latitude: String,
        longitude: String,
        page: Int,
        completion: @escaping (Result<FlickrSearchResults, Error>) -> Void
    ) {
        
        let request = makegetPhotosRequest(latitude: latitude, longitude: longitude, page: page)
        
        let task = makegetPhotosTask(
            request: request,
            completion: completion)
        task.resume()
    }
}