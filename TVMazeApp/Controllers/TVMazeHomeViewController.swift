//
//  TVMazeHomeViewController.swift
//  TVMazeApp
//
//  Created by Lautaro Galan on 27/12/2022.
//

import UIKit

protocol TVMazeHomeViewControllerProtocol {
    func handleError(error: TVMazeServiceError, comments: String?)
    func reloadView()
    func setUpViewPresenter()
    func showDetailView(view: UIViewController)
}

class TVMazeHomeViewController: UIViewController {
    var viewPresenter: TVMazeHomeViewPresenterProtocol?

    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var previousPageButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var pageNumber: Int = 0

    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTable()
        setUpViewPresenter()
        viewPresenter?.fetchAllAndPopulate(tableView: resultTableView, pageNumber: pageNumber)
    }
    
    // MARK: Private Methods
    
    private func setUpView() {
        // TODO: Localized strings for each button and label instead of hardcoded string
        searchTextField.clearButtonMode = .whileEditing
    }

    private func setUpTable() {
        resultTableView.dataSource = self
        resultTableView.delegate = self
        resultTableView.register(UINib(nibName: "TVMazeShowCellTableViewCell", bundle: nil), forCellReuseIdentifier: "showcell")
    }
    
    private func validateTableArrows() {
        if pageNumber < 1 {
            previousPageButton.isEnabled = false
        } else {
            previousPageButton.isEnabled = true
        }
    }
    
    // MARK: Outlets
    @IBAction func loadNextPage(_ sender: Any) {
        // TODO: Handle cell loading
        pageNumber += 1
        viewPresenter?.fetchAllAndPopulate(tableView: resultTableView, pageNumber: pageNumber)
        validateTableArrows()
    }
    
    @IBAction func loadPreviousPage(_ sender: Any) {
        pageNumber -= 1
        viewPresenter?.fetchAllAndPopulate(tableView: resultTableView, pageNumber: pageNumber)
        validateTableArrows()

    }
    
    @IBAction func reloadTable(_ sender: Any) {
        pageNumber = 0
        viewPresenter?.fetchAllAndPopulate(tableView: resultTableView, pageNumber: pageNumber)
        validateTableArrows()
    }
    
    @IBAction func searchShows(_ sender: Any) {
        viewPresenter?.fetchShowAndPopulate(tableView: resultTableView, showName: searchTextField.text ?? "")
    }
}

// MARK: TVMazeHomeViewControllerProtocol
extension TVMazeHomeViewController: TVMazeHomeViewControllerProtocol {
    func reloadView() {
        DispatchQueue.main.async {
            self.resultTableView.reloadData()
        }
    }
    
    func setUpViewPresenter() {
        if viewPresenter == nil {
            let service = TVMazeNetworkService(session: .shared)
            viewPresenter = TVMazeHomeViewPresenter(delegate: self, service: service)
        }
    }
    
    func showDetailView(view: UIViewController) {
        self.present(view, animated: false)
    }
    
    func handleError(error: TVMazeServiceError, comments: String?) {
        // TODO: Handle view without content disabling components or error view for example
    }
}

// MARK: UITableView
extension TVMazeHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let presenter = viewPresenter {
            return presenter.tableRowCount()
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        if let cell = resultTableView.dequeueReusableCell(withIdentifier: "showcell") as? TVMazeShowCellTableViewCell {
            viewPresenter?.setupCell(cell: cell, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewPresenter?.PresentDetailedView(index: indexPath)
    }
}
