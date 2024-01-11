//
//  SenseiDetailViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 1/10/24.
//


import UIKit
import CoreData

class SenseisDetailViewController: UIViewController {
    
    //Label names
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var armorLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var luckLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!

    //The values to the names above
    @IBOutlet weak var skylanderSpeed: UILabel!
    @IBOutlet weak var skylanderArmor: UILabel!
    @IBOutlet weak var skylanderAttack: UILabel!
    @IBOutlet weak var skylanderLuck: UILabel!
    @IBOutlet weak var skylanderHealth: UILabel!
    
    //Other properties
    @IBOutlet weak var skylanderImage: UIImageView!
    @IBOutlet weak var compatableGames: UILabel!
    @IBOutlet weak var skylanderSeries: UILabel!
    @IBOutlet weak var skylanderGame: UILabel!
    @IBOutlet weak var senseiBattleClass: UILabel!
    
    var chosenSensei: NSManagedObject!
    lazy var name = chosenSensei.value(forKey: "name") as! String
    lazy var baseName = chosenSensei.value(forKey: "baseName") as! String
    lazy var series = chosenSensei.value(forKey: "series") as! Int
    lazy var image = getImage()
    lazy var game = chosenSensei.value(forKey: "game") as! String
    lazy var statsName = chosenSensei.value(forKey: "statsName") as! String
    lazy var variant = chosenSensei.value(forKey: "variantText") as! String
    
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
        if let image = ConfigureImage(skylander: chosenSensei) {
            return image
        }
        else {
            return UIImage(systemName: "square")!
        }
    }
    
    private func configureSeries() -> String {
        if series == 0 {
            let variant = chosenSensei?.value(forKey: "variantText") as! String
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
            senseiBattleClass.text = String(describing: skylanderStats.value(forKey: "battleClass")!)
            let speedStat = skylanderStats.value(forKey: "speed") as! Int
            skylanderSpeed.text = speedStat != -1 ? String(speedStat) : "Unknown"
            let armorStat = skylanderStats.value(forKey: "armor") as! Int
            skylanderArmor.text = armorStat != -1 ? String(armorStat) : "Unknown"
            let criticalHitStat = skylanderStats.value(forKey: "attack") as! Int
            skylanderAttack.text = criticalHitStat != -1 ? String(criticalHitStat) : "Unknown"
            let elementalPowerStat = skylanderStats.value(forKey: "luck") as! Int
            skylanderLuck.text = elementalPowerStat != -1 ? String(elementalPowerStat) : "Unknown"
            let startingHealthStat = skylanderStats.value(forKey: "health") as! Int
            skylanderHealth.text = startingHealthStat != -1 ? String(startingHealthStat) : "Unknown"
        }
        else {
            senseiBattleClass.text = "Unknown"
            skylanderSpeed.text = "Unknown"
            skylanderArmor.text = "Unknown"
            skylanderAttack.text = "Unknown"
            skylanderLuck.text = "Unknown"
            skylanderHealth.text = "Unknown"
        }
        setCompatibleGames()
    }
    
    private func setCompatibleGames() {
        var displayString = ""
        if chosenSensei.value(forKey: "worksWithSpyrosAdventure") as! Bool {
            displayString += "Spyro's Adventure\n"
        }
        if chosenSensei.value(forKey: "worksWithGiants") as! Bool {
            displayString += "Giants\n"
        }
        if chosenSensei.value(forKey: "worksWithSwapForce") as! Bool {
            displayString += "Swap Force\n"
        }
        if chosenSensei.value(forKey: "worksWithTrapTeam") as! Bool {
            displayString += "Trap Team\n"
        }
        if chosenSensei.value(forKey: "worksWithSuperChargers") as! Bool {
            displayString += "SuperChargers\n"
        }
        if chosenSensei.value(forKey: "worksWithImaginators") as! Bool {
            displayString += "Imaginators"
        }
        
        compatableGames.text = displayString
    }
    
    // MARK: - Data Functions
    private func getStats() -> NSManagedObject? {
        let statsList = RefreshData(entityName: "SenseisStatsTable")!
        for imaginatorsStats in statsList {
            if imaginatorsStats.value(forKey: "statsName") as! String == statsName {
                return imaginatorsStats
            }
        }
        return nil

    }
}

