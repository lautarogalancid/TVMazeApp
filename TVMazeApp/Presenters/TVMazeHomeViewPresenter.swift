//
//  TVMazeHomeViewPresenter.swift
//  TVMazeApp
//
//  Created by Lautaro Galan on 28/12/2022.
//

import UIKit

// TODO: Move protocols to their own file and layer
protocol TVMazeHomeViewPresenterProtocol {
    func fetchAllAndPopulate(tableView: UITableView, pageNumber: Int)
    func fetchShowAndPopulate(tableView: UITableView, showName: String)
    func tableRowCount() -> Int
    func setupCell(cell: TVMazeShowCellTableViewCellProtocol, indexPath: IndexPath)
    func PresentDetailedView(index: IndexPath)
}

class TVMazeHomeViewPresenter: TVMazeHomeViewPresenterProtocol {
    private let delegate: TVMazeHomeViewControllerProtocol
    private let service: TVMazeNetworkServiceProtocol
    
    private var showsArray: [TVMazeShowModel]?
    
    init(delegate: TVMazeHomeViewControllerProtocol, service: TVMazeNetworkServiceProtocol) {
        self.delegate = delegate
        self.service = service
    }
    
    func fetchAllAndPopulate(tableView: UITableView, pageNumber: Int) {
        service.fetchAllShows(page: pageNumber) {[weak self] (model, err) in
            guard let self = self else {return}
            if let modelArray = model {
                self.clearTableView()
                self.showsArray = modelArray
                self.delegate.reloadView()
            } else {
                if let error = err {
                    self.delegate.handleError(error: error, comments: nil)
                } else {
                    self.delegate.handleError(error: .unknown, comments: "Something else happened")
                }
            }
        }
    }

    func fetchShowAndPopulate(tableView: UITableView, showName: String) {
        service.fetchShow(name: showName) {[weak self] (model, err) in
            guard let self = self else {return}
            if let modelArray = model {
                self.clearTableView()
                let showsResponse = modelArray.map({(response: TVMazeNetworkResponseModel) -> TVMazeShowModel in
                    response.show
                })
                self.showsArray = showsResponse
                self.delegate.reloadView()
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
    
    func PresentDetailedView(index: IndexPath) {
        if let models = showsArray {
            let selectedModel = models[index.row]
            let presenter = TVMazeShowDetailsPresenter(model: selectedModel, service: service)
            if let detailView = presenter.createView() as? UIViewController {
                
                self.delegate.showDetailView(view: detailView)
            }
        }
    }
    
    // MARK: Private methods
    
    private func clearTableView() {
        self.showsArray = nil
        self.delegate.reloadView()
    }
}
