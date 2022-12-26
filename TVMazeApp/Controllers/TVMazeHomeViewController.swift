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
}

class TVMazeHomeViewController: UIViewController {
    var viewPresenter: TVMazeHomeViewPresenterProtocol?

    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpViewPresenter()
        viewPresenter?.fetchAndPopulate(tableView: resultTableView)
    }
    
    func setUpTable() {
        resultTableView.dataSource = self
        resultTableView.delegate = self
        resultTableView.register(UINib(nibName: "TVMazeShowCellTableViewCell", bundle: nil), forCellReuseIdentifier: "showcell")
    }
}

extension TVMazeHomeViewController: TVMazeHomeViewControllerProtocol {
    func reloadView() {
        self.resultTableView.reloadData()
    }
    
    func setUpViewPresenter() {
        if viewPresenter == nil {
            let service = TVMazeNetworkService(session: .shared)
            viewPresenter = TVMazeHomeViewPresenter(delegate: self, service: service)
        }
    }
}

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
    
    func handleError(error: TVMazeServiceError, comments: String?) {
        // TODO: Handle view without content disabling components or something else?
    }
}
