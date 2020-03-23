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

}
