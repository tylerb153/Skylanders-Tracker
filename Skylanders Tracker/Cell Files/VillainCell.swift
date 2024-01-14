//
//  VillainCell.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 1/11/24.
//

import UIKit
import CoreData

class VillainCell: UITableViewCell {
    
    var isChecked = false
    var villain: NSManagedObject?
    var trapDetails: NSManagedObject?
    
    @IBOutlet weak var villainName: UILabel!
    @IBOutlet weak var villainImage: UIImageView!
    @IBOutlet weak var checkmarkImage: UIButton!
    
    var villainStatsName: String {villain!.value(forKey: "statsName") as! String}
    
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
        villainName.text = givenName
    }
    
    private func setImage(givenImage: UIImage?) {
        if givenImage != nil {
            villainImage.image = givenImage
        }
        else {
            villainImage.image = UIImage(systemName: "square")
        }
    }
    
    private func setChecked(givenCheck: Bool) {
        if givenCheck {
            checkmarkImage.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.normal)
            isChecked = true
            var villainsTrappedArray: [String] = getTrappedVillains()
            if !villainsTrappedArray.contains(villainStatsName) {
                villainsTrappedArray.append(villainStatsName)
                trapDetails!.setValue(villainsTrappedArray, forKey: "villiansCaptured")
            }
            saveTrap()
//            print(trapDetails!.value(forKey: "villiansCaptured") as! [String])
        }
        else {
            checkmarkImage.setImage(UIImage(systemName: "checkmark.circle"), for: UIControl.State.normal)
            isChecked = false
            var villainsTrappedArray: [String] = getTrappedVillains()
            if villainsTrappedArray.contains(villainStatsName) {
                villainsTrappedArray.removeAll { $0 == villainStatsName}
                trapDetails!.setValue(villainsTrappedArray, forKey: "villiansCaptured")
            }
            saveTrap()
        }
        villain?.setValue(checkVillainChecked(), forKey: "isChecked")
        saveTrap()
//        print("This is the array called from the database \(trapDetails?.value(forKey: "villiansCaptured") as! [String])")
    }
    
    //MARK: - Helper Methods
    private func checkVillainChecked() -> Bool {
        let trapArray = RefreshData(entityName: "TrapDetails") ?? []
        for i in trapArray {
            let statsName = villainStatsName
            if ((i.value(forKey: "villiansCaptured") as! [String]).contains(statsName)) {
                return true
            }
        }
        return false
    }
    
    
    // MARK: - Configure Cell Methods
    
    func configure(for villain: NSManagedObject, chosenTrap trapDetails: NSManagedObject?) {
        self.villain = villain
        self.trapDetails = trapDetails
        let name = villain.value(forKey: "name") as! String
        var check: Bool {
            let villainsTrappedArray = getTrappedVillains()
            if  villainsTrappedArray.contains(villainStatsName) {
                return true
            }
            else {
                return false
            }
        }
//        print(check)
        setName(givenName: name)
        setImage(givenImage: ConfigureImage(skylander: villain))
        setChecked(givenCheck: check)
    }
    
    // MARK: - Save Checkmark
    private func saveTrap() {
        
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
    
    private func getTrappedVillains() -> [String] {
        guard let villainsTrappedArray: [String] = trapDetails?.value(forKey: "villiansCaptured") as? [String] else {
            print("Could not get villains trapped array in VillainCell")
            return [""]
        }
//        print(villainsTrappedArray)
        return villainsTrappedArray
    }
}

