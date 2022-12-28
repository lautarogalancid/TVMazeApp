//
//  TVMazeHomeViewPresenter.swift
//  TVMazeApp
//
//  Created by Lautaro Galan on 28/12/2022.
//

import UIKit

// TODO: Move protocols to their own file and layer
protocol TVMazeHomeViewPresenterProtocol {
    func setupView(view: TVMazeHomeViewControllerProtocol)
    func fetchAndPopulate(tableView: UITableView, pageNumber: Int)
    func tableRowCount() -> Int
    func setupCell(cell: TVMazeShowCellTableViewCellProtocol, indexPath: IndexPath)
}

class TVMazeHomeViewPresenter: TVMazeHomeViewPresenterProtocol {
    let delegate: TVMazeHomeViewControllerProtocol
    let service: TVMazeNetworkServiceProtocol
    
    private var showsArray: [TVMazeShowModel]?
    
    init(delegate: TVMazeHomeViewControllerProtocol, service: TVMazeNetworkServiceProtocol) {
        self.delegate = delegate
        self.service = service
    }
    
    func setupView(view: TVMazeHomeViewControllerProtocol) {
    }
    
    func fetchAndPopulate(tableView: UITableView, pageNumber: Int) {
        service.fetchAllShows(page: pageNumber) {[weak self] (model, err) in
            guard let self = self else {return}
            
            if let modelArray = model {
                self.showsArray = modelArray
                DispatchQueue.main.async {
                    self.delegate.reloadView()
                }
            } else {
                if let error = err {
                    self.delegate.handleError(error: error, comments: nil)
                } else {
                    self.delegate.handleError(error: .unknown, comments: "Something else happened")
                }
            }
        }
    }
    
    func tableRowCount() -> Int {
        guard let array = showsArray else { return 0 }
        return array.count
    }
    
    func setupCell(cell: TVMazeShowCellTableViewCellProtocol, indexPath: IndexPath) {
        if let models = showsArray {
            let model = models[indexPath.row] as TVMazeShowModel
            var cellImage: UIImage? = nil
            var imageUrl: String? = nil
            
            if let originalSizeUrl = model.image["original"] {
                imageUrl = originalSizeUrl
            }
            
            service.downloadImage(imageUrl: imageUrl) {[weak self] (image, err) in
                guard let self = self else {return}

                if let validImage = image {
                    cellImage = validImage
                    DispatchQueue.main.async {
                        cell.setupCell(model: model, image: cellImage)
                    }
                } else {
                    if let error = err {
                        self.delegate.handleError(error: error, comments: nil)
                    } else {
                        self.delegate.handleError(error: .unknown, comments: "Something else happened")
                    }
                }
            }
            
        }
    }
}
