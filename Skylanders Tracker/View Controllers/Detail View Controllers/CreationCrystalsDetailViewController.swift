//
//  CreationCrystalDetailViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 1/16/24.
//

import UIKit
import CoreData

class CreationCrystalsDetailViewController: UIViewController {
    
    //The values to the names above
    @IBOutlet weak var elementLabel: UILabel!
    
    //Other properties
    @IBOutlet weak var skylanderImage: UIImageView!
    @IBOutlet weak var compatableGames: UILabel!
    @IBOutlet weak var skylanderSeries: UILabel!
    @IBOutlet weak var skylanderGame: UILabel!
    
    var chosenCreationCrystal: NSManagedObject!
    lazy var name = chosenCreationCrystal.value(forKey: "name") as! String
    lazy var baseName = chosenCreationCrystal.value(forKey: "baseName") as! String
    lazy var series = chosenCreationCrystal.value(forKey: "series") as! Int
    lazy var image = getImage()
    lazy var game = chosenCreationCrystal.value(forKey: "game") as! String
    lazy var statsName = chosenCreationCrystal.value(forKey: "statsName") as! String
    lazy var variant = chosenCreationCrystal.value(forKey: "variantText") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        skylanderSeries.text = configureSeries()
        skylanderImage.image = image
        skylanderGame.text = game
        tintGame()
        setLabels()
//        if variant == "Dark" {
//            skylanderImage.backgroundColor = UIColor.black
//        }
        skylanderImage.layer.cornerRadius = skylanderImage.bounds.width / 5
    }
    
    // MARK: - Helper Functions
    private func getImage() -> UIImage {
        if let image = ConfigureImage(skylander: chosenCreationCrystal) {
            return image
        }
        else {
            return UIImage(systemName: "square")!
        }
    }
    
    private func configureSeries() -> String {
        if variant == "Eon's Elite" {
            skylanderSeries.backgroundColor = UIColor(named: "Elite Gold")
        }
        if series == 0 {
            let variant = chosenCreationCrystal?.value(forKey: "variantText") as! String
            return variant
        }
        else {
            return "Series \(series)"
        }
    }
    
    private func tintGame() {
        let color = UIColor(named: game)
        
        skylanderGame.backgroundColor = color
    }
    
    private func setLabels() {
        if let creationCrystalDetails = getDetails() {
            let element = creationCrystalDetails.value(forKey: "element") as! String
            elementLabel.text = element
        }
        else {
            elementLabel.text = "Unknown"
        }
        setCompatibleGames()
    }
    
    private func setCompatibleGames() {
        var displayString = ""
        if chosenCreationCrystal.value(forKey: "worksWithSpyrosAdventure") as! Bool {
            displayString += "Spyro's Adventure\n"
        }
        if chosenCreationCrystal.value(forKey: "worksWithGiants") as! Bool {
            displayString += "Giants\n"
        }
        if chosenCreationCrystal.value(forKey: "worksWithSwapForce") as! Bool {
            displayString += "Swap Force\n"
        }
        if chosenCreationCrystal.value(forKey: "worksWithTrapTeam") as! Bool {
            displayString += "Trap Team\n"
        }
        if chosenCreationCrystal.value(forKey: "worksWithSuperChargers") as! Bool {
            displayString += "SuperChargers\n"
        }
        if chosenCreationCrystal.value(forKey: "worksWithImaginators") as! Bool {
            displayString += "Imaginators"
        }
        
        compatableGames.text = displayString
    }
    
    // MARK: - Data Functions
    private func getDetails() -> NSManagedObject? {
        let statsList = RefreshData(entityName: "CreationCrystalsDetailsTable")!
        for skylanderStats in statsList {
            if skylanderStats.value(forKey: "statsName") as! String == statsName {
                return skylanderStats
            }
        }
        return nil

    }
}

