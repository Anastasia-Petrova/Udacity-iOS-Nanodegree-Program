//
//  UdacityClientTests.swift
//  UdacityClientTests
//
//  Created by Anastasia Petrova on 23/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import OnTheMap

final class UdacityClientTests: XCTestCase {

    func test_make_sessionID_request() {
        let sessionIdRequest = UdacityClient.makeSessionIDRequest(username: "Alex", password: "12345")
        XCTAssertEqual(sessionIdRequest.url, URL(string: "https://onthemap-api.udacity.com/v1/session"))
        XCTAssertEqual(sessionIdRequest.httpMethod, "POST")
        XCTAssertEqual(sessionIdRequest.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(sessionIdRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(sessionIdRequest.httpBody, "{\"udacity\": {\"username\": \"Alex\", \"password\": \"12345\"}}".data(using: .utf8))

    }
    
    func test_make_sessionID_task() {
        let expectedRequest = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        let task = UdacityClient.makeSessionIDTask(request: expectedRequest)
        XCTAssertEqual(task.originalRequest, expectedRequest)
    }
    
    func test_make_get_user_info_request() {
        let key = "12345"
        let request = UdacityClient.makeGetUserInfoRequest(key: key)
        XCTAssertEqual(request.url, URL(string: "https://onthemap-api.udacity.com/v1/users/\(key)"))
    }
    
    func test_make_get_user_info_task() {
        let expectedRequest = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        let task = UdacityClient.makeGetUserInfoTask(request: expectedRequest)
        XCTAssertEqual(task.originalRequest, expectedRequest)
    }
    
}
