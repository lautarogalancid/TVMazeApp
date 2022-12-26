//
//  TVMazeNetworkService.swift
//  TVMaze
//
//  Created by Lautaro Galan on 26/12/2022.
//

import UIKit

protocol TVMazeNetworkServiceProtocol {
    func fetchAllShows(page: Int, completion: @escaping ([TVMazeShowModel]?, TVMazeServiceError?) -> Void)
    func downloadImage(imageUrl: String?, completion: @escaping (UIImage?, TVMazeServiceError?) -> Void)
}

class TVMazeNetworkService: TVMazeNetworkServiceProtocol {
    private var session: URLSession = .shared
    private let baseUrl: String = "https://api.tvmaze.com"
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchAllShows(page: Int, completion: @escaping ([TVMazeShowModel]?, TVMazeServiceError?) -> Void) {
        let urlString = "\(baseUrl)/shows?page=\(page)"
        guard let requestUrl = URL(string: urlString) else {
            completion(nil, TVMazeServiceError.responseInvalidURL)
            return
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data, let responseModel = try? JSONDecoder().decode([TVMazeShowModel].self, from: data) {
                completion(responseModel, nil)
            } else {
                completion(nil, TVMazeServiceError.responseParsingError)
            }
        }
        task.resume()
    }
    
    func downloadImage(imageUrl: String?, completion: @escaping (UIImage?, TVMazeServiceError?) -> Void) {
        if let validImageUrl = imageUrl {
            guard let requestUrl = URL(string: validImageUrl) else {
                completion(nil, TVMazeServiceError.responseInvalidURL)
                return
            }
            let task = session.dataTask(with: requestUrl) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image, nil)
                } else {
                    completion(nil, .invalidImageUrl)
                }
            }
            task.resume()
        }
    }
}
