//
//  GameCell.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/21/22.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(gameName: String) {
        self.gameName.text = gameName
        let defaultImage = UIImage(systemName: "gamecontroller")!
        switch gameName {
        case "Spyro's Adventure": if let gameImage = UIImage(named: "Spyro's Adventure Game Icon") {
            gameImageView.image = gameImage
            }
            else {
                gameImageView.image = defaultImage
            }
        case "Giants": if let gameImage = UIImage(named: "Giants Game Icon") {
            gameImageView.image = gameImage
            }
            else {
                gameImageView.image = defaultImage
            }
        case "Swap Force": if let gameImage = UIImage(named: "Swap Force Game Icon") {
            gameImageView.image = gameImage
            }
            else {
                gameImageView.image = defaultImage
            }
        case "Trap Team": if let gameImage = UIImage(named: "Trap Team Game Icon") {
            gameImageView.image = gameImage
            }
            else {
                gameImageView.image = defaultImage
            }
        case "SuperChargers": if let gameImage = UIImage(named: "SuperChargers Game Icon") {
            gameImageView.image = gameImage
            }
            else {
                gameImageView.image = defaultImage
            }
        case "Imaginators": if let gameImage = UIImage(named: "Imaginators Game Icon") {
            gameImageView.image = gameImage
            }
            else {
                gameImageView.image = defaultImage
            }
        default: gameImageView.image = defaultImage
        }
    }
}
