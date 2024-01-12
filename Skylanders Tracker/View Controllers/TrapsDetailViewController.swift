//
//  TrapsDetailViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 8/29/22.
//

import UIKit
import CoreData

class TrapsDetailViewController: UIViewController {
    @IBOutlet var trapImage: UIImageView!
    @IBOutlet var villianLabel: UILabel!
    @IBOutlet var trapElementLabel: UILabel!
    @IBOutlet var trapDesignLabel: UILabel!
    @IBOutlet var villianTitle: UILabel!
    
    var chosenTrap: NSManagedObject!
    lazy var name = chosenTrap.value(forKey: "name") as! String
    lazy var statsName = chosenTrap.value(forKey: "statsName") as! String
    
    
    override func viewDidLoad() {
        navigationItem.title = name
        SetImage()
        SetLabels()
    }
    
//MARK: - Helper Functions
    private func SetImage() {
        if let image = ConfigureImage(skylander: chosenTrap) {
            trapImage.image = image
        }
        else {
            trapImage.image = UIImage(systemName: "square")
        }
    }
    
    private func SetLabels() {
        let trapDetails = getDetails()
//        print(trapDetails)
        if trapDetails != nil {
            trapElementLabel.text = trapDetails!.value(forKey: "element") as? String
            trapDesignLabel.text = trapDetails!.value(forKey: "design") as? String
            let villiansCaptured = trapDetails?.value(forKey: "villiansCaptured") as? [String] ?? [""]
            
            var capturedVilliansString = ""
            for i in villiansCaptured {
                capturedVilliansString += "\(i)\n"
            }
            print(capturedVilliansString)
            villianLabel.text = capturedVilliansString
//            print(trapDetails!.value(forKey: "villiansCaptured") as? [String] ?? "Default Value")
        }
        else {
            trapElementLabel.text = ""
            trapDesignLabel.text = ""
            villianLabel.text = ""
            
            villianTitle.isHidden = true
        }
        
    }
    
    private func getDetails() -> NSManagedObject? {
        let detailsList = RefreshData(entityName: "TrapDetails")!
        for i in detailsList {
            if statsName == i.value(forKey: "statsName") as! String {
                return i
            }
        }
        
        return nil
    }
}
