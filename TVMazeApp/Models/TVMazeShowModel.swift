//
//  TVMazeShowModel.swift
//  TVMaze
//
//  Created by Lautaro Galan on 26/12/2022.
//

import Foundation
import UIKit

struct TVMazeShowModel: Codable {
    let name: String
    let image: [String: String]
    let premiered: String
    let ended: String?
    let genres: [String]
    let summary: String
    // TODO: Seasons object property
}
