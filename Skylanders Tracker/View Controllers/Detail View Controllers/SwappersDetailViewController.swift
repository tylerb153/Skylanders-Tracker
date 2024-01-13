//
//  SwappersDetailViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 1/9/24.
//

import UIKit
import CoreData

class SwappersDetailViewController: UIViewController {
    
    //Label names
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var armorLabel: UILabel!
    @IBOutlet weak var criticalHitLabel: UILabel!
    @IBOutlet weak var elementalPowerLabel: UILabel!
    @IBOutlet weak var startHealthLabel: UILabel!
    @IBOutlet weak var maximumHealthLabel: UILabel!

    //The values to the names above
    @IBOutlet weak var skylanderSpeed: UILabel!
    @IBOutlet weak var skylanderArmor: UILabel!
    @IBOutlet weak var skylanderCriticalHit: UILabel!
    @IBOutlet weak var skylanderElementalPower: UILabel!
    @IBOutlet weak var skylanderStartHealth: UILabel!
    @IBOutlet weak var skylanderMaximumHealth: UILabel!
    
    //Other properties
    @IBOutlet weak var skylanderImage: UIImageView!
    @IBOutlet weak var compatableGames: UILabel!
    @IBOutlet weak var skylanderSeries: UILabel!
    @IBOutlet weak var skylanderGame: UILabel!
    @IBOutlet weak var swapperMovementType: UILabel!
    
    var chosenSwapper: NSManagedObject!
    lazy var name = chosenSwapper.value(forKey: "name") as! String
    lazy var baseName = chosenSwapper.value(forKey: "baseName") as! String
    lazy var series = chosenSwapper.value(forKey: "series") as! Int
    lazy var image = getImage()
    lazy var game = chosenSwapper.value(forKey: "game") as! String
    lazy var statsName = chosenSwapper.value(forKey: "statsName") as! String
    lazy var variant = chosenSwapper.value(forKey: "variantText") as! String
    
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
        if let image = ConfigureImage(skylander: chosenSwapper) {
            return image
        }
        else {
            return UIImage(systemName: "square")!
        }
    }
    
    private func configureSeries() -> String {
        if series == 0 {
            let variant = chosenSwapper?.value(forKey: "variantText") as! String
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
        if let skylanderStats = getStats() {
            swapperMovementType.text = String(describing: skylanderStats.value(forKey: "movementType")!)
            let speedStat = skylanderStats.value(forKey: "speed") as! Int
            skylanderSpeed.text = speedStat != -1 ? String(speedStat) : "Unknown"
            let armorStat = skylanderStats.value(forKey: "armor") as! Int
            skylanderArmor.text = armorStat != -1 ? String(armorStat) : "Unknown"
            let criticalHitStat = skylanderStats.value(forKey: "criticalHit") as! Int
            skylanderCriticalHit.text = criticalHitStat != -1 ? String(criticalHitStat) : "Unknown"
            let elementalPowerStat = skylanderStats.value(forKey: "elementalPower") as! Int
            skylanderElementalPower.text = elementalPowerStat != -1 ? String(elementalPowerStat) : "Unknown"
            let startingHealthStat = skylanderStats.value(forKey: "startingHealth") as! Int
            skylanderStartHealth.text = startingHealthStat != -1 ? String(startingHealthStat) : "Unknown"
            let maxHealthStat = skylanderStats.value(forKey: "maxHealth") as! Int
            skylanderMaximumHealth.text = maxHealthStat != -1 ? String(maxHealthStat) : "Unknown"
            
        }
        else {
            swapperMovementType.text = "Unknown"
            skylanderSpeed.text = "Unknown"
            skylanderArmor.text = "Unknown"
            skylanderCriticalHit.text = "Unknown"
            skylanderElementalPower.text = "Unknown"
            skylanderStartHealth.text = "Unknown"
            skylanderMaximumHealth.text = "Unknown"
        }
        setCompatibleGames()
    }
    
    private func setCompatibleGames() {
        var displayString = ""
        if chosenSwapper.value(forKey: "worksWithSpyrosAdventure") as! Bool {
            displayString += "Spyro's Adventure\n"
        }
        if chosenSwapper.value(forKey: "worksWithGiants") as! Bool {
            displayString += "Giants\n"
        }
        if chosenSwapper.value(forKey: "worksWithSwapForce") as! Bool {
            displayString += "Swap Force\n"
        }
        if chosenSwapper.value(forKey: "worksWithTrapTeam") as! Bool {
            displayString += "Trap Team\n"
        }
        if chosenSwapper.value(forKey: "worksWithSuperChargers") as! Bool {
            displayString += "SuperChargers\n"
        }
        if chosenSwapper.value(forKey: "worksWithImaginators") as! Bool {
            displayString += "Imaginators"
        }
        
        compatableGames.text = displayString
    }
    
    // MARK: - Data Functions
    private func getStats() -> NSManagedObject? {
        let statsList = RefreshData(entityName: "SwapperStatsTable")!
        for swapperStats in statsList {
            if swapperStats.value(forKey: "statsName") as! String == statsName {
                return swapperStats
            }
        }
        return nil

    }
}
