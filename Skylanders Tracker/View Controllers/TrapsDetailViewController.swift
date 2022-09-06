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
    
    var chosenTrap: NSManagedObject!
    lazy var name = chosenTrap.value(forKey: "name") as! String
    
    
    override func viewDidLoad() {
        SetImage()
//        SetLabels()
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
    }
}
