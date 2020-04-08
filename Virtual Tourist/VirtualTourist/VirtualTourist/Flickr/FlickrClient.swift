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
    
    enum NetworkError: LocalizedError {
        case noData
        case wrongAPIResponse
        
        var errorDescription: String? {
            switch self {
            case .noData, .wrongAPIResponse: return "Something went wrong. Try again later."
            }
        }
    }
    
    class func makeGetPhotosRequest(latitude: String, longitude: String) -> URLRequest {
        let page = Int.random(in: 1..<30)
        let url = URL(string: Endpoints.getPhotosForLocation(lat: latitude, lon: longitude, page: page).stringValue)!
        return URLRequest(url: url)
    }
    
    class func makeGetPhotosTask(
        session: URLSession = .shared,
        request: URLRequest,
        completion: @escaping (Result<FlickrSearchResults, Error>) -> Void
    ) -> URLSessionDataTask {
        return session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
                return
            }
            
            guard let _ = response as? HTTPURLResponse,
                let data = data else {
                    DispatchQueue.main.async { completion(Result.failure(NetworkError.wrongAPIResponse))
                    }
                    return
            }
            
            do {
                guard
                    let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
                    let stat = resultsDictionary["stat"] as? String,
                    stat == "ok"
                    else {
                        DispatchQueue.main.async {
                            completion(Result.failure(NetworkError.wrongAPIResponse))
                        }
                        return
                }
                
                guard
                    let photosContainer = resultsDictionary["photos"] as? [String: AnyObject],
                    let photosReceived = photosContainer["photo"] as? [[String: AnyObject]]
                    else {
                        DispatchQueue.main.async { completion(Result.failure(NetworkError.wrongAPIResponse))
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
                    return flickrPhoto
                }
                let searchResults = FlickrSearchResults(searchResults: flickrPhotos)
                DispatchQueue.main.async {
                    completion(Result.success(searchResults))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    class func getPhotos(
        latitude: String,
        longitude: String,
        completion: @escaping (Result<FlickrSearchResults, Error>) -> Void
    ) {
        
        let request = makeGetPhotosRequest(latitude: latitude, longitude: longitude)
        
        let task = makeGetPhotosTask(
            request: request,
            completion: completion)
        task.resume()
    }
}
