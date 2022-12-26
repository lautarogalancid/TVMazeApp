//
//  MockURLProtocol.swift
//  TVMazeAppTests
//
//  Created by Lautaro Galan on 26/12/2022.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var stubData: Data?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        self.client?.urlProtocol(self, didLoad: MockURLProtocol.stubData ?? Data())
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}
