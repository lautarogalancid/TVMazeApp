//
//  TVMazeShowDetailsViewController.swift
//  TVMazeApp
//
//  Created by Lautaro Galan on 28/12/2022.
//

import UIKit

protocol TVMazeShowDetailsViewControllerProtocol {
    func createWithPresenter(presenter: TVMazeShowDetailsPresenterProtocol)
    func loadPoster(image: UIImage)
    func handleError(error: TVMazeServiceError, comments: String?)
}

class TVMazeShowDetailsViewController: UIViewController {
    private var viewPresenter: TVMazeShowDetailsPresenterProtocol?

    @IBOutlet weak var posterImageContainer: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var premieredLabel: UILabel!
    @IBOutlet weak var endedLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!

    /*
     @IBOutlet weak var nameLabel: UILabel!
     ○ Name
     ○ Poster
     ○ Days and time during which the series airs
     ○ Genres
     ○ Summary
     ○ List of episodes separated by season
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        // TODO: Handle empty model
        guard let model = viewPresenter?.modelForView() else { return }
        
        if let name = nameLabel {
            name.text = model.name
            premieredLabel.text = model.premiered
            endedLabel.text = model.ended
            let genres = model.genres.joined(separator: ", ")
            genresLabel.text = genres
            viewPresenter?.setUpPoster(imageUrl: model.image["original"] ?? "")
        }
    }

}

extension TVMazeShowDetailsViewController: TVMazeShowDetailsViewControllerProtocol {
    func loadPoster(image: UIImage) {
        posterImageContainer.image
        = image
    }
    
    func createWithPresenter(presenter: TVMazeShowDetailsPresenterProtocol) {
        viewPresenter = presenter
    }
    func handleError(error: TVMazeServiceError, comments: String?) {
        // TODO: Handle view errors
    }
}
