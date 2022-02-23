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
    func setSeries(givenSeries: Int) {
        if givenSeries == 0 {
            seriesNumber.text = ""
        }
        else {
            seriesNumber.text = "Series \(givenSeries)"
        }
    }
    
    func setImage(givenImage: UIImage?) {
        if givenImage != nil {
            skylanderImage.image = givenImage
        }
        else {
            skylanderImage.image = UIImage(systemName: "square")
        }
    }
    
    func configure(name: String, series: Int) {
        setName(givenName: name)
        setSeries(givenSeries: series)
        setImage(givenImage: UIImage(named: configureName(name: name, series: series)))
    }
    
    private func configureName(name: String, series: Int) -> String {
        if series == 0 {
            return "\(name)1"
        }
        else {
            return "\(name)\(series)"
        }
    }
}
