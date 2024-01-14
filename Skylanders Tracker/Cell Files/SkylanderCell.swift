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
    var isVillain: Bool {
        if variant.contains("Villian") || variant.contains("Doom Raider") {
            return true
        } else {
            return false
        }
    }
    
    var skylander: NSManagedObject?
    var variant: String = ""
    
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
        if isVillain {
            return
        }
    
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
            if isVillain {
                checkmarkImage.setImage(UIImage(systemName: "checkmark"), for: UIControl.State.normal)
            } else {
                checkmarkImage.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.normal)
            }
            isChecked = true
            skylander!.setValue(true, forKey: "isChecked")
            saveSkylander()
        }
        else {
            if isVillain {
                checkmarkImage.setImage(UIImage(systemName: "xmark"), for: UIControl.State.normal)
            } else {
                checkmarkImage.setImage(UIImage(systemName: "checkmark.circle"), for: UIControl.State.normal)
            }
            isChecked = false
            skylander!.setValue(false, forKey: "isChecked")
            saveSkylander()
        }
    }
    
    
    //MARK: - Helper Methods
    func findVillainChecked() -> Bool {
        guard let trapDetailsArray = RefreshData(entityName: "TrapDetails") else {
            return false
        }
        for trap in trapDetailsArray {
            let villainsTrapped = trap.value(forKey: "villiansCaptured") as! [String]
            if villainsTrapped.contains(skylander?.value(forKey: "statsName") as! String) {
                return true
            }
            
        }
        return false
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
        setImage(givenImage: ConfigureImage(skylander: skylander))
        tintBorder()
        variant = skylander.value(forKey: "variantText") as? String ?? ""
        if isVillain {
            setChecked(givenCheck: findVillainChecked())
        } else {
            setChecked(givenCheck: check)
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
