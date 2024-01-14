//
//  DataBuilder.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/21/22.
//

import Foundation
import CoreData
import UIKit

class DataBuilder {
    
    private static var jsonSkylanders: [SkylanderObject] = []
    private static var jsonStats: [SkylandersStats] = []
    private static var jsonSwapperStats: [SwapperStats] = []
    private static var jsonTrapDetails: [TrapsDetails] = []
    private static var jsonSuperChargerStats: [SuperChargersStats] = []
    private static var jsonSenseiStats: [SenseisStats] = []
    private static var jsonVillainDetails: [VillianDetails] = []
    
    // MARK: - JSON parse
    private static func getData(type dataType: String) -> Data? {
        var name = ""
        switch dataType {
        case "Data":
            name = "Skylanders Data"
        case "Stats":
            name = "Skylanders Stats"
        case "Traps":
            name = "Traps Details"
        case "Swappers":
            name = "Swappers Stats"
        case "SuperChargers":
            name = "SuperChargers Stats"
        case "Senseis":
            name = "Senseis Stats"
        case "Villains":
            name = "Villians Details"
        default:
            print("Error in getData in DataBuilder with type \(dataType)")
            return nil
        }
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                    return jsonData
            }
        }
        catch {
            print(error)
            }
            return nil
    }
    
    private static func parseJson(type dataType: String) {
        guard let data = getData(type: dataType) else {print("error in parseJSON with type \(dataType)"); return}
        
        let decoder = JSONDecoder()
        switch dataType {
        case "Data":
            if dataType == "Data" {
                if let result = try? decoder.decode(SkylandersObjectList.self, from: data) {
                    jsonSkylanders = result.Skylanders
//                    print(jsonSkylanders)
                }
                else {
                    print("Error in decode \(dataType) in DataBuilder")
                }
            }
           
        case "Stats":
            if let result = try? decoder.decode(SkylandersStatsList.self, from: data) {
                jsonStats = result.SkylandersStats
//                print(jsonStats)
            }
            else {
                print("Error in decode \(dataType) in DataBuilder")
            }
            
        case "Traps":
            if let result = try? decoder.decode(TrapsDetailsList.self, from: data) {
//                print(result.TrapDetails[0])
                jsonTrapDetails = result.TrapDetails
            }
            else {
                print("Error in decode \(dataType) in DataBuilder")
            }
        
        case "Swappers":
            if let result = try? decoder.decode(SwapperStatsList.self, from: data) {
                jsonSwapperStats = result.SwapperStats
            }
            else {
                print("Error in decode \(dataType) in DataBuilder")
            }
        
        case "SuperChargers":
            if let result = try? decoder.decode(SuperChargersStatsList.self, from: data) {
                jsonSuperChargerStats = result.SuperChargersStats
            }
            else {
                print("Error in decode \(dataType) in DataBuilder")
            }
        case "Senseis":
            if let result = try? decoder.decode(SenseisStatsList.self, from: data) {
                jsonSenseiStats = result.SenseisStats
            }
            else {
                print("Error in decode \(dataType) in DataBuilder")
            }
        case "Villains":
            if let result = try? decoder.decode(VillianDetailsList.self, from: data) {
                jsonVillainDetails = result.VillianDetails
            }
            else {
                print("Error in decode \(dataType) in DataBuilder")
            }
           
        default: print("Incorrect Data Type")
        }
    }
    
    public static func saveData() {
        print("Saving Data")
        parseJson(type: "Data")
        parseJson(type: "Stats")
        parseJson(type: "Traps")
        parseJson(type: "Swappers")
        parseJson(type: "SuperChargers")
        parseJson(type: "Senseis")
        parseJson(type: "Villains")
        
        for jsonSkylander in jsonSkylanders {
            saveSkylander(jsonSkylander: jsonSkylander)
        }
        for jsonStat in jsonStats {
            saveStats(jsonStats: jsonStat)
        }
        for jsonTrapDetail in jsonTrapDetails {
            saveTrapDetails(jsonTrapDetails: jsonTrapDetail)
        }
        for jsonSwapperStat in jsonSwapperStats {
            saveSwapperStats(jsonSwapperStats: jsonSwapperStat)
        }
        for jsonSuperChargerStat in jsonSuperChargerStats {
            saveSuperChargerStats(jsonSuperChargerStats: jsonSuperChargerStat)
        }
        for jsonSenseiStat in jsonSenseiStats {
            saveSenseiStats(jsonSenseiStats: jsonSenseiStat)
        }
        for jsonVillainDetail in jsonVillainDetails {
            saveVillainDetails(jsonVillainDetails: jsonVillainDetail)
        }
    }
    
    private static func saveSkylander(jsonSkylander: SkylanderObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Skylander", in: managedContext)!
        
        let skylander = NSManagedObject(entity: entity, insertInto: managedContext)
        skylander.setValue(jsonSkylander.name, forKey: "name")
        skylander.setValue(jsonSkylander.game, forKey: "game")
        skylander.setValue(jsonSkylander.series, forKey: "series")
        skylander.setValue(jsonSkylander.baseName, forKey: "baseName")
        skylander.setValue(jsonSkylander.isChecked, forKey: "isChecked")
        skylander.setValue(jsonSkylander.variantText, forKey: "variantText")
        skylander.setValue(jsonSkylander.statsName, forKey: "statsName")
        skylander.setValue(jsonSkylander.worksWithSpyrosAdventure, forKey: "worksWithSpyrosAdventure")
        skylander.setValue(jsonSkylander.worksWithGiants, forKey: "worksWithGiants")
        skylander.setValue(jsonSkylander.worksWithSwapForce, forKey: "worksWithSwapForce")
        skylander.setValue(jsonSkylander.worksWithTrapTeam, forKey: "worksWithTrapTeam")
        skylander.setValue(jsonSkylander.worksWithSuperChargers, forKey: "worksWithSuperChargers")
        skylander.setValue(jsonSkylander.worksWithImaginators, forKey: "worksWithImaginators")
        
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private static func saveStats(jsonStats: SkylandersStats) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SkylanderStats", in: managedContext)!
        
        let stats = NSManagedObject(entity: entity, insertInto: managedContext)
        stats.setValue(jsonStats.statsName, forKey: "statsName")
        stats.setValue(jsonStats.element, forKey: "element")
        stats.setValue(jsonStats.speed, forKey: "speed")
        stats.setValue(jsonStats.armor, forKey: "armor")
        stats.setValue(jsonStats.criticalHit, forKey: "criticalHit")
        stats.setValue(jsonStats.elementalPower, forKey: "elementalPower")
        stats.setValue(jsonStats.maxHealth, forKey: "maxHealth")
        stats.setValue(jsonStats.startingHealth, forKey: "startingHealth")
        
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private static func saveTrapDetails(jsonTrapDetails: TrapsDetails) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TrapDetails", in: managedContext)!
        
        let trapDetail = NSManagedObject(entity: entity, insertInto: managedContext)
        trapDetail.setValue(jsonTrapDetails.statsName, forKey: "statsName")
        trapDetail.setValue(jsonTrapDetails.element, forKey: "element")
        trapDetail.setValue(jsonTrapDetails.design, forKey: "design")
        trapDetail.setValue(jsonTrapDetails.villiansCaptured, forKey: "villiansCaptured")
//        print(trapDetail.value(forKey: "villainsCaptured") as! [String])
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private static func saveSwapperStats(jsonSwapperStats: SwapperStats) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SwapperStatsTable", in: managedContext)!
        
        let swapperStat = NSManagedObject(entity: entity, insertInto: managedContext)
        swapperStat.setValue(jsonSwapperStats.statsName, forKey: "statsName")
        swapperStat.setValue(jsonSwapperStats.element, forKey: "element")
        swapperStat.setValue(jsonSwapperStats.movementType, forKey: "movementType")
        swapperStat.setValue(jsonSwapperStats.speed, forKey: "speed")
        swapperStat.setValue(jsonSwapperStats.armor, forKey: "armor")
        swapperStat.setValue(jsonSwapperStats.criticalHit, forKey: "criticalHit")
        swapperStat.setValue(jsonSwapperStats.elementalPower, forKey: "elementalPower")
        swapperStat.setValue(jsonSwapperStats.maxHealth, forKey: "maxHealth")
        swapperStat.setValue(jsonSwapperStats.startingHealth, forKey: "startingHealth")
        
        do {
//            print(jsonSwapperStats)
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private static func saveSuperChargerStats(jsonSuperChargerStats: SuperChargersStats) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SuperChargerStatsTable", in: managedContext)!
        
        let swapperStat = NSManagedObject(entity: entity, insertInto: managedContext)
        swapperStat.setValue(jsonSuperChargerStats.statsName, forKey: "statsName")
        swapperStat.setValue(jsonSuperChargerStats.element, forKey: "element")
        swapperStat.setValue(jsonSuperChargerStats.vehicle, forKey: "vehicle")
        swapperStat.setValue(jsonSuperChargerStats.speed, forKey: "speed")
        swapperStat.setValue(jsonSuperChargerStats.armor, forKey: "armor")
        swapperStat.setValue(jsonSuperChargerStats.criticalHit, forKey: "criticalHit")
        swapperStat.setValue(jsonSuperChargerStats.elementalPower, forKey: "elementalPower")
        swapperStat.setValue(jsonSuperChargerStats.maxHealth, forKey: "maxHealth")
        swapperStat.setValue(jsonSuperChargerStats.startingHealth, forKey: "startingHealth")
//        print(swapperStat.value(forKey: "vehicle"))
        do {
//            print(jsonSuperChargerStats)
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private static func saveSenseiStats(jsonSenseiStats: SenseisStats) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SenseisStatsTable", in: managedContext)!
        
        let senseiStat = NSManagedObject(entity: entity, insertInto: managedContext)
        senseiStat.setValue(jsonSenseiStats.statsName, forKey: "statsName")
        senseiStat.setValue(jsonSenseiStats.element, forKey: "element")
        senseiStat.setValue(jsonSenseiStats.battleClass, forKey: "battleClass")
        senseiStat.setValue(jsonSenseiStats.speed, forKey: "speed")
        senseiStat.setValue(jsonSenseiStats.armor, forKey: "armor")
        senseiStat.setValue(jsonSenseiStats.attack, forKey: "attack")
        senseiStat.setValue(jsonSenseiStats.luck, forKey: "luck")
        senseiStat.setValue(jsonSenseiStats.health, forKey: "health")
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private static func saveVillainDetails(jsonVillainDetails: VillianDetails) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "VillianDetailsTable", in: managedContext)!
        
        let VillainDetail = NSManagedObject(entity: entity, insertInto: managedContext)
        VillainDetail.setValue(jsonVillainDetails.statsName, forKey: "statsName")
        VillainDetail.setValue(jsonVillainDetails.element, forKey: "element")
        VillainDetail.setValue(jsonVillainDetails.specialTrap, forKey: "specialTrap")
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func DeleteData() {
        print("Deleting Data")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
    let fetchRequestList = [
        NSFetchRequest<NSManagedObject>(entityName: "Skylander"),
        NSFetchRequest<NSManagedObject>(entityName: "SkylanderStats"),
        NSFetchRequest<NSManagedObject>(entityName: "TrapDetails"),
        NSFetchRequest<NSManagedObject>(entityName: "SwapperStatsTable"),
        NSFetchRequest<NSManagedObject>(entityName: "SuperChargerStatsTable"),
        NSFetchRequest<NSManagedObject>(entityName: "SenseisStatsTable"),
        NSFetchRequest<NSManagedObject>(entityName: "VillianDetailsTable")
    ]
        
        for i in fetchRequestList {
            do {
                let list = try managedContext.fetch(i)
                for j in list {
                    managedContext.delete(j)
                }
            }
            catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
