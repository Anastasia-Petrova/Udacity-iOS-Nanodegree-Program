//
//  UdacityClientTests.swift
//  UdacityClientTests
//
//  Created by Anastasia Petrova on 23/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import OnTheMap

//TODO: test rest of network functions
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
        let task = UdacityClient.makeSessionIDTask(request: expectedRequest) { result in
            
        }
        XCTAssertEqual(task.originalRequest, expectedRequest)
    }
    
    func test_make_students_locations_request() {
        let request = UdacityClient.makeStudentsLocationsRequest()
        XCTAssertEqual(request.url, URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?skip=8386&limit=100&order=-updatedAt"))
    }
    
    func test_make_students_locations_task() {
        let expectedRequest = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?skip=8386&limit=100&order=createdAt")!)
        let task = UdacityClient.makeStudentsLocationsTask(
        request: expectedRequest) { result in
            
        }
        XCTAssertEqual(task.originalRequest, expectedRequest)
    }
    
    func test_make_post_user_location_request() {
        let postLocationRequest = UdacityClient.makePostUserLocationRequest(
            firstName: "Ann",
            lastName: "Ann",
            location: "Kiev",
            link: "",
            latitude: 1.0,
            longitude: 1.0
        )
        
        XCTAssertEqual(postLocationRequest.url, URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation"))
        XCTAssertEqual(postLocationRequest.httpMethod, "POST")
        XCTAssertEqual(postLocationRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    func test_make_post_user_location_task() {
        let expectedRequest = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        let task = UdacityClient.makePostUserLocationTask(
            request: expectedRequest) { result in
                
            }
        XCTAssertEqual(task.originalRequest, expectedRequest)
    }
    
    func test_get_user_info_request() {
        let getUserInfoRequest = UdacityClient.getUserInfoRequest(accountKey: "123456789")
        XCTAssertEqual(getUserInfoRequest.url, URL(string: "https://onthemap-api.udacity.com/v1/users/123456789"))
    }
    
    func test_get_user_info_task() {
        let expectedRequest = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/123456789")!)
        let task = UdacityClient.getUserInfoTask(
            request: expectedRequest){ result in
                
            }
        XCTAssertEqual(task.originalRequest, expectedRequest)
    }
    
    func test_make_logaout_request() {
        let getUserInfoRequest = UdacityClient.makeLogaoutRequest()
        XCTAssertEqual(getUserInfoRequest.url, URL(string: "https://onthemap-api.udacity.com/v1/session"))
        XCTAssertEqual(getUserInfoRequest.httpMethod, "DELETE")
    }
    
    func test_make_logaout_task() {
        let expectedRequest = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        let task = UdacityClient.makeLogoutTask( request: expectedRequest) { result in
                
            }
        XCTAssertEqual(task.originalRequest, expectedRequest)
    }
}
