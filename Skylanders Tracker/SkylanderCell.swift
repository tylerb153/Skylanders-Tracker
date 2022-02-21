//
//  SkylanderCell.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/21/22.
//

import UIKit

class SkylanderCell: UITableViewCell {

    @IBOutlet weak var skylanderName: UILabel!
    @IBOutlet weak var seriesNumber: UILabel!
    @IBOutlet weak var skylanderImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setName(givenName: String) {
        skylanderName.text = givenName
    }
    func setSeries(givenSeries: String) {
        seriesNumber.text = givenSeries
    }
    func setImage(givenImage: UIImage) {
        skylanderImage.image = givenImage
    }
    
    func configure(name: String, series: String) {
        setName(givenName: name)
        setSeries(givenSeries: series)
    }
    func configure(name: String, series: String, image: UIImage) {
        setName(givenName: name)
        setSeries(givenSeries: series)
        setImage(givenImage: image)
    }
}
