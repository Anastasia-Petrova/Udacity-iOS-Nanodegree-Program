//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 20/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
    }
    
    class func requestSessionID(username: String, password: String) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                //TODO: Handle error…
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let range = (5..<data.count)
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(RequestSessionIDResponse.self, from: newData)
                Auth.sessionId = responseObject.session.id
                print("sessionID: \(responseObject.session.id)")
            } catch {
                //TODO: Handle error…
                print(error)
            }
        }
        task.resume()
    }
}
