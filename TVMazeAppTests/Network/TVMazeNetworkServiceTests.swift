//
//  TVMazeNetworkServiceTests.swift
//  TVMazeTests
//
//  Created by Lautaro Galan on 26/12/2022.
//

import XCTest
@testable import TVMazeApp

final class TVMazeNetworkServiceTests: XCTestCase {
    // SMELL: for some reason the setup method isn't working properly and won't let me instance the sut, check later
    
    // I started doing this with TDD but due to personal time constraints (Holiday season, also i'm leaving on vacations by thursday so i'm wrapping things up in my current job and i'm also in a couple more selection processes so i'm really full atm) i had to drop it, these were done using TDD tho
    
    func testWhenFetchingAllShows_ReturnsValidResponse() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        let sut = TVMazeNetworkService(session: urlSession)

        let pathString = Bundle(for: type(of: self)).path(forResource: "FetchAll", ofType: "json")
        let jsonString = try? String(contentsOfFile: pathString!, encoding: .utf8)
        MockURLProtocol.stubData = jsonString!.data(using: .utf8)

        let expectation = self.expectation(description: "Fetch Request")
        
        sut.fetchShows(param: String(0), fetchType: .fetchAll) {(model, err) in
            let out: TVMazeShowModel = model![0]
            XCTAssertEqual(out.name, "Under the Dome")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testWhenFetchingAllShows_ReturnsParsingError() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        let jsonString = ""
        MockURLProtocol.stubData = jsonString.data(using: .utf8)
        
        let sut = TVMazeNetworkService(session: urlSession)

        let expectation = self.expectation(description: "Invalid or empty Json received")
        
        sut.fetchShows(param: String(0), fetchType: .fetchAll) {(model, err) in
            XCTAssertNil(model)
            XCTAssertEqual(err, TVMazeServiceError.responseParsingError)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 1)
    }
}
