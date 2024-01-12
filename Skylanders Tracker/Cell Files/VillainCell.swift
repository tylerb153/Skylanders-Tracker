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
    
    @IBOutlet weak var villainName: UILabel!
    @IBOutlet weak var villainImage: UIImageView!
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
//            skylander!.setValue(true, forKey: "isChecked")
//            saveSkylander()
        }
        else {
            checkmarkImage.setImage(UIImage(systemName: "checkmark.circle"), for: UIControl.State.normal)
            isChecked = false
//            skylander!.setValue(false, forKey: "isChecked")
//            saveSkylander()
        }
    }
    
    // MARK: - Configure Cell Methods
    
    func configure(for villain: NSManagedObject) {
        self.villain = villain
        let name = villain.value(forKey: "name") as! String
        let check = false
        setName(givenName: name)
        setImage(givenImage: ConfigureImage(skylander: villain))
        setChecked(givenCheck: check)
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

