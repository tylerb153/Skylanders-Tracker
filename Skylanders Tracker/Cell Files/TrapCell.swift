//
//  TrapCell.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 1/12/24.
//

import UIKit
import CoreData

class TrapCell: UITableViewCell {
    
    var isChecked = false
    var trap: NSManagedObject?
    var villainDetails: NSManagedObject?
    
    @IBOutlet weak var villainName: UILabel!
    @IBOutlet weak var villainImage: UIImageView!
    @IBOutlet weak var checkmarkImage: UIButton!
    
    lazy var statsName = trap!.value(forKey: "statsName") as! String
    var trapDetails: NSManagedObject? {getDetails()}
    lazy var villainStatsName = villainDetails?.value(forKey: "statsName") as! String
    
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
//        print(trap?.value(forKey: "name") as! String + " is check as \(isChecked) before setChecked runs and givenCheck is \(givenCheck)")
        if givenCheck {
            checkmarkImage.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.normal)
            isChecked = true
            var villainsTrappedArray: [String] = getTrappedVillains()
            if !villainsTrappedArray.contains(villainStatsName) {
                villainsTrappedArray.append(villainStatsName)
                trapDetails!.setValue(villainsTrappedArray, forKey: "villiansCaptured")
            }
            saveTrap()
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
        let villain = getVillain()
        villain?.setValue(checkVillainChecked(), forKey: "isChecked")
        saveTrap()
        
//        print(trap?.value(forKey: "name") as! String + " is check as \(isChecked) after setChecked saves and givenCheck is \(givenCheck) it should now appear to be checked as \(isChecked)\n")
//        print("This is the array called from the database \(trapDetails?.value(forKey: "villiansCaptured") as! [String])")
    }
    
    private func getDetails() -> NSManagedObject? {
        let detailsList = RefreshData(entityName: "TrapDetails")!
        //        print(detailsList)
        for i in detailsList {
            if trap?.value(forKey: "statsName") as! String == i.value(forKey: "statsName") as! String {
                //                print(i)
                return i
            }
        }
        return nil
    }
    
    private func getVillainDetails(villainStatsName: String) -> NSManagedObject? {
        guard let villainDetails = RefreshData(entityName: "VillianDetailsTable") else {
            return nil
        }
        for i in villainDetails {
            if villainStatsName == i.value(forKey: "statsName") as! String {
                return i
            }
        }
        return nil
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
    
    private func getVillain() -> NSManagedObject? {
        let skylandersList = RefreshData(entityName: "Skylander") ?? []
        for skylander in skylandersList {
            if skylander.value(forKey: "statsName") as! String == villainStatsName {
                return skylander
            }
        }
        return nil
    }
    
    // MARK: - Configure Cell Methods
    
    func configure(for trap: NSManagedObject, villainDetails: NSManagedObject) {
        self.trap = trap
        self.villainDetails = villainDetails
        let name = trap.value(forKey: "name") as! String
//        print("------Configured------")
//        print(name)
        var check: Bool {
            let villainsTrappedArray = getTrappedVillains()
//            print(villainsTrappedArray)
            if  villainsTrappedArray.contains(villainStatsName) {
                return true
            }
            else {
                return false
            }
        }
//        print("\(check)\n")
        setName(givenName: name)
        setImage(givenImage: ConfigureImage(skylander: trap))
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
        return villainsTrappedArray
    }
}
