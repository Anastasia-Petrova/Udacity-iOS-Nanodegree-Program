//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 20/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

final class UdacityClient {
    enum NetworkError: Error {
        case noData
    }
    
    class func makeSessionIDRequest(username: String, password: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        return request
    }
    
    class func makeSessionIDTask(
        session: URLSession = .shared,
        request: URLRequest,
        completion: @escaping (Result<RequestSessionIDResponse, Error>) -> Void
    ) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let range = (5..<data.count)
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(RequestSessionIDResponse.self, from: newData)
                completion(.success(responseObject))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    class func performSessionIDRequest(
        username: String,
        password: String,
        completion: @escaping (Result<RequestSessionIDResponse, Error>) -> Void
    ) {
        let request = makeSessionIDRequest(username: username, password: password)
        let task = makeSessionIDTask(request: request, completion: completion)

        task.resume()
    }
    
    class func makeStudentsLocationsRequest() -> URLRequest {
        return URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100")!)
    }
    
    class func makeStudentsLocationsTask(
        session: URLSession = .shared,
        request: URLRequest,
        completion: @escaping (Result<Locations, Error>) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let locations = try decoder.decode(Locations.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(locations))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    class func getStudentsLocations(completion: @escaping (Result<Locations, Error>) -> Void) {
        let request = makeStudentsLocationsRequest()
        let task = makeStudentsLocationsTask(
            request: request,
            completion: completion)
        
        task.resume()
    }
    
    class func makeGetUserInfoRequest(key: String) -> URLRequest {
        return URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(key)")!)
    }
    
    class func makeGetUserInfoTask(session: URLSession = .shared, request: URLRequest) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
    }
    
    class func getUserInfo(key: String) {
        let request = makeGetUserInfoRequest(key: key)
        let task = makeGetUserInfoTask(request: request)
        
        task.resume()
    }
    
    class func makeLogoutRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        return request
    }
    
    class func makeLogoutTask(session: URLSession = .shared, request: URLRequest) -> URLSessionDataTask {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        return task
    }
    
    class func logout() {
        //TODO: Extract Request and Task creation into separate function and test them
        let request = makeLogoutRequest()
        let task = makeLogoutTask(request: request)
        task.resume()
    }
}
