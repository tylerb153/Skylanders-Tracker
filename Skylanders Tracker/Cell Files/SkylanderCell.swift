//
//  SkylanderCell.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/21/22.
//

import UIKit
import CoreData

class SkylanderCell: UITableViewCell {

    var isChecked = false
    
    @IBOutlet weak var skylanderName: UILabel!
    @IBOutlet weak var seriesNumber: UILabel!
    @IBOutlet weak var skylanderImage: UIImageView!
    @IBOutlet weak var checkmarkImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: Action
    @IBAction func toggleCheckmark(_ sender: Any) {
        if isChecked {
            setChecked(givenCheck: false)
        }
        else {
            setChecked(givenCheck: true)
        }
    }
    
    // MARK: - Set Labels Methods
    func setName(givenName: String) {
        skylanderName.text = givenName
    }
    func setSeries(givenSeries: Int) {
        seriesNumber.text = "Series \(givenSeries)"
    }
    
    func setImage(givenImage: UIImage?) {
        if givenImage != nil {
            skylanderImage.image = givenImage
        }
        else {
            skylanderImage.image = UIImage(systemName: "square")
        }
    }
    
    func setChecked(givenCheck: Bool) {
        if givenCheck {
            checkmarkImage.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.normal)
            isChecked = true
        }
        else {
            checkmarkImage.setImage(UIImage(systemName: "checkmark.circle"), for: UIControl.State.normal)
            isChecked = false
        }
    }
    
    // MARK: - Configure Cell Methods
    
    func configure(for skylander: NSManagedObject) {
        let name = skylander.value(forKey: "name") as! String
        let series = skylander.value(forKey: "series") as! Int
        let check = skylander.value(forKey: "isChecked") as! Bool
        setName(givenName: name)
        setSeries(givenSeries: series)
        setImage(givenImage: UIImage(named: configureName(name: name, series: series)))
        setChecked(givenCheck: check)
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
