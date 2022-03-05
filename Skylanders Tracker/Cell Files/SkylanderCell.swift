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
    var skylander: NSManagedObject?
    
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
    private func setName(givenName: String) {
        skylanderName.text = givenName
    }
    private func setSeries(givenSeries: Int) {
        if givenSeries == 0 {
            seriesNumber.text = ""
        }
        else {
            seriesNumber.text = "Series \(givenSeries)"
        }
    }
    
    private func setImage(givenImage: UIImage?) {
        if givenImage != nil {
            skylanderImage.image = givenImage
        }
        else {
            skylanderImage.image = UIImage(systemName: "square")
        }
    }
    
    private func setChecked(givenCheck: Bool) {
        if givenCheck {
            checkmarkImage.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.normal)
            isChecked = true
            skylander!.setValue(true, forKey: "isChecked")
            saveSkylander()
        }
        else {
            checkmarkImage.setImage(UIImage(systemName: "checkmark.circle"), for: UIControl.State.normal)
            isChecked = false
            skylander!.setValue(false, forKey: "isChecked")
            saveSkylander()
        }
    }
    
    // MARK: - Configure Cell Methods
    
    func configure(for skylander: NSManagedObject) {
        self.skylander = skylander
        let name = skylander.value(forKey: "name") as! String
//        let baseName = skylander.value(forKey: "baseName") as! String
        let series = skylander.value(forKey: "series") as! Int
        let check = skylander.value(forKey: "isChecked") as! Bool
        setName(givenName: name)
        setSeries(givenSeries: series)
        setImage(givenImage: UIImage(named: configureName(name: name, series: series)))
        tintBorder()
        setChecked(givenCheck: check)
    }
    
    private func configureName(name: String, series: Int) -> String {
//        return "\(name)1"
        if series == 0 {
            return "\(name)1"
        }
        else {
            return "\(name)\(series)"
        }
    }
    
    private func tintBorder() {
        let game = skylander?.value(forKey: "game") as! String
        let color = UIColor(named: game)?.cgColor
        
        skylanderImage.layer.masksToBounds = true
        skylanderImage.layer.borderWidth = 1
        skylanderImage.layer.borderColor = color
        
        skylanderImage.layer.cornerRadius = skylanderImage.bounds.width / 5
    }
    
    // MARK: - Save Checkmark
    private func saveSkylander() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
