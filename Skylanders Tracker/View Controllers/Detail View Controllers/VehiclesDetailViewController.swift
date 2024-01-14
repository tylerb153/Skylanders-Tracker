//
//  VehiclesDetailViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 1/14/24.
//

import UIKit
import CoreData

class VehiclesDetailViewController: UIViewController {
    
    //The stats values
    @IBOutlet weak var vehicleTopSpeed: UILabel!
    @IBOutlet weak var vehicleAcceleration: UILabel!
    @IBOutlet weak var vehicleArmor: UILabel!
    @IBOutlet weak var vehicleHandling: UILabel!
    @IBOutlet weak var vehicleWeight: UILabel!
    
    //Other properties
    @IBOutlet weak var vehicleTerrain: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var compatableGames: UILabel!
    @IBOutlet weak var vehicleSeries: UILabel!
    @IBOutlet weak var vehicleGame: UILabel!
    @IBOutlet weak var vehicleSuperCharger: UILabel!
    
    var chosenVehicle: NSManagedObject!
    lazy var name = chosenVehicle.value(forKey: "name") as! String
    lazy var baseName = chosenVehicle.value(forKey: "baseName") as! String
    lazy var series = chosenVehicle.value(forKey: "series") as! Int
    lazy var image = getImage()
    lazy var game = chosenVehicle.value(forKey: "game") as! String
    lazy var statsName = chosenVehicle.value(forKey: "statsName") as! String
    lazy var variant = chosenVehicle.value(forKey: "variantText") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        vehicleSeries.text = configureSeries()
        vehicleImage.image = image
        vehicleGame.text = game
        tintGame()
        setLabels()
//        if variant == "Dark" {
//            skylanderImage.backgroundColor = UIColor.black
//        }
        vehicleImage.layer.cornerRadius = vehicleImage.bounds.width / 5
    }
    
    // MARK: - Helper Functions
    private func getImage() -> UIImage {
        if let image = ConfigureImage(skylander: chosenVehicle) {
            return image
        }
        else {
            return UIImage(systemName: "square")!
        }
    }
    
    private func configureSeries() -> String {
        if series == 0 {
            let variant = chosenVehicle?.value(forKey: "variantText") as! String
            return variant
        }
        else {
            return "Series \(series)"
        }
    }
    
    private func tintGame() {
        let color = UIColor(named: game)
        
        vehicleGame.backgroundColor = color
    }
    
    private func setLabels() {
        if let vehicleStats = getStats() {
            vehicleSuperCharger.text = String(describing: getSuperCharger()?.value(forKey: "name") ?? "")
            vehicleTerrain.text = vehicleStats.value(forKey: "terrain") as? String ?? "Unknown"
            let topSpeed = vehicleStats.value(forKey: "topSpeed") as! Int
            vehicleTopSpeed.text = topSpeed != -1 ? String(topSpeed) : "Unknown"
            let acceleration = vehicleStats.value(forKey: "acceleration") as! Int
            vehicleAcceleration.text = acceleration != -1 ? String(acceleration) : "Unknown"
            let armor = vehicleStats.value(forKey: "armor") as! Int
            vehicleArmor.text = armor != -1 ? String(armor) : "Unknown"
            let handling = vehicleStats.value(forKey: "handling") as! Int
            vehicleHandling.text = handling != -1 ? String(handling) : "Unknown"
            let weight = vehicleStats.value(forKey: "weight") as! Int
            vehicleWeight.text = weight != -1 ? String(weight) : "Unknown"
        }
        else {
            vehicleSuperCharger.text = "Unknown"
            vehicleTopSpeed.text = "Unknown"
            vehicleAcceleration.text = "Unknown"
            vehicleArmor.text = "Unknown"
            vehicleHandling.text = "Unknown"
            vehicleWeight.text = "Unknown"
        }
        setCompatibleGames()
    }
    
    private func setCompatibleGames() {
        var displayString = ""
        if chosenVehicle.value(forKey: "worksWithSpyrosAdventure") as! Bool {
            displayString += "Spyro's Adventure\n"
        }
        if chosenVehicle.value(forKey: "worksWithGiants") as! Bool {
            displayString += "Giants\n"
        }
        if chosenVehicle.value(forKey: "worksWithSwapForce") as! Bool {
            displayString += "Swap Force\n"
        }
        if chosenVehicle.value(forKey: "worksWithTrapTeam") as! Bool {
            displayString += "Trap Team\n"
        }
        if chosenVehicle.value(forKey: "worksWithSuperChargers") as! Bool {
            displayString += "SuperChargers\n"
        }
        if chosenVehicle.value(forKey: "worksWithImaginators") as! Bool {
            displayString += "Imaginators"
        }
        
        compatableGames.text = displayString
    }
    
    // MARK: - Data Functions
    private func getStats() -> NSManagedObject? {
        let statsList = RefreshData(entityName: "VehicleStatsTable")!
        for vehicleStat in statsList {
            if vehicleStat.value(forKey: "statsName") as! String == statsName {
                return vehicleStat
            }
        }
        return nil
    }
    private func getSuperCharger() -> NSManagedObject? {
        guard let superChargerStats = RefreshData(entityName: "SuperChargerStatsTable") else {
            return nil
        }
        guard let skylandersList = RefreshData(entityName: "Skylander") else {
            return nil
        }
        var superChargerVehicleOptions: [String] = []
        for superCharger in superChargerStats  {
            superChargerVehicleOptions.append(superCharger.value(forKey: "vehicle") as! String )
        }
//        print(superChargerVehicleOptions)
        for superChargerStat in superChargerStats {
//            print(superChargerStat.value(forKey: "statsName"))
            let superChargerStatsName = superChargerStat.value(forKey: "statsName") as! String
            let superChargerVehicle = superChargerStat.value(forKey: "vehicle") as! String
//            print(superChargerVehicle + " " + name)
            if superChargerVehicleOptions.contains(name) && superChargerVehicle == name {
                for skylander in skylandersList {
                    if (skylander.value(forKey: "statsName") as! String) == superChargerStatsName {
//                        print(skylander)
//                        print(superChargerStat)
                        return skylander
                    }
                }
            } else if !superChargerVehicleOptions.contains(name) && superChargerVehicle == statsName {
                for skylander in skylandersList {
                    if (skylander.value(forKey: "statsName") as! String) == superChargerStatsName {
//                        print(skylander)
//                        print(superChargerStat)
                        return skylander
                    }
                }
            }
        }
        return nil
    }
}

