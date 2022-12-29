//
//  TVMazeShowDetailsPresenter.swift
//  TVMazeApp
//
//  Created by Lautaro Galan on 28/12/2022.
//

import UIKit

protocol TVMazeShowDetailsPresenterProtocol {
    func modelForView() -> TVMazeShowModel
    func createView() -> TVMazeShowDetailsViewControllerProtocol
    func setUpPoster(imageUrl: String)
}

class TVMazeShowDetailsPresenter: TVMazeShowDetailsPresenterProtocol{
    private let model: TVMazeShowModel
    private let delegate: TVMazeShowDetailsViewControllerProtocol
    private let service: TVMazeNetworkServiceProtocol
    
    init(model: TVMazeShowModel, service: TVMazeNetworkServiceProtocol) {
        let view = TVMazeShowDetailsViewController()
        self.delegate = view
        self.model = model
        self.service = service
    }
    
    func modelForView() -> TVMazeShowModel {
        return model
    }
    
    func createView() -> TVMazeShowDetailsViewControllerProtocol {
        delegate.createWithPresenter(presenter: self)
        return delegate
    }
    
    func setUpPoster(imageUrl: String) {
      
        service.downloadImage(imageUrl: imageUrl) {[weak self] (image, err) in
            guard let self = self else {return}

            if let validImage = image {
                DispatchQueue.main.async {
                    self.delegate.loadPoster(image: validImage)
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
