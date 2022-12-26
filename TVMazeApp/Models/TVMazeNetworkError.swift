//
//  TVMazeServiceError.swift
//  TVMaze
//
//  Created by Lautaro Galan on 26/12/2022.
//

import Foundation

enum TVMazeServiceError: Error {
    case responseParsingError
    case responseInvalidURL
    case invalidImageUrl
    case unknown
}
