//
//  SkylanderSelectCell.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/25/22.
//

import UIKit
import CoreData

class SkylanderSelectCell: UITableViewCell {

    @IBOutlet weak var skylanderName: UILabel!
    @IBOutlet weak var skylanderImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Set Labels Methods
    func setName(givenName: String) {
        skylanderName.text = givenName
    }
    
    func setImage(givenImage: UIImage?) {
        if givenImage != nil {
            skylanderImage.image = givenImage
        }
        else {
            skylanderImage.image = UIImage(systemName: "square")
        }
    }
    
    // MARK: - Configure Cell Methods
    
    func configure(for skylander: NSManagedObject) {
        let name = skylander.value(forKey: "name") as! String
        let baseName = skylander.value(forKey: "baseName") as! String
        let series = skylander.value(forKey: "series") as! Int
        setName(givenName: name)
        setImage(givenImage: UIImage(named: configureName(name: baseName, series: series)))
    }
    
    private func configureName(name: String, series: Int) -> String {
        return "\(name)1"
        if series == 0 {
            return "\(name)1"
        }
        else {
            return "\(name)\(series)"
        }
    }
}
