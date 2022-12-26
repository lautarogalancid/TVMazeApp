//
//  TVMazeShowCellTableViewCell.swift
//  TVMazeApp
//
//  Created by Lautaro Galan on 28/12/2022.
//

import UIKit

protocol TVMazeShowCellTableViewCellProtocol {
    func setupCell(model: TVMazeShowModel, image: UIImage?)
}

class TVMazeShowCellTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension TVMazeShowCellTableViewCell: TVMazeShowCellTableViewCellProtocol {
    func setupCell(model: TVMazeShowModel, image: UIImage?) {
        // TODO: Handle loading/downloading cells with spinner
        if let nameLabel = name, let posterContainer = poster {
            nameLabel.text = model.name
            
            if let cellImage = image {
                posterContainer.image = cellImage
            } else {
                // TODO: generic image
            }
        }
    }
}
