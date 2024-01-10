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
    @IBOutlet weak var checkmark: UIImageView!
    
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
    
    func updateCheckmark(checked: Bool) {
        if checked {
            checkmark.image = UIImage(systemName: "checkmark")
        }
        else {
            checkmark.image = UIImage()
        }
    }
    
    func configure(for skylander: NSManagedObject) {
//        let name = skylander.value(forKey: "name") as! String
        let baseName = skylander.value(forKey: "baseName") as! String
        setName(givenName: baseName)
        setImage(givenImage: ConfigureImage(skylander: skylander))
    }
}
