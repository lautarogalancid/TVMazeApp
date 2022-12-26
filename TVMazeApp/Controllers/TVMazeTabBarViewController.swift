//
//  TVMazeTabBarViewController.swift
//  TVMazeApp
//
//  Created by Lautaro Galan on 27/12/2022.
//

import UIKit

class TVMazeTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: move to it's own presenter
        let home = TVMazeHomeViewController()
        home.title = "Home"
        self.setViewControllers([home], animated: false)
        guard let items = self.tabBar.items else { return }
        items[0].image = UIImage(systemName: "house")

    }
}
