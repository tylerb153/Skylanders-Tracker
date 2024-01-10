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
        default:
            print("Error in getData in DataBuilder")
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
        guard let data = getData(type: dataType) else {print("error in parseJSON"); return}
        
        let decoder = JSONDecoder()
        switch dataType {
        case "Data":
            if dataType == "Data" {
                if let result = try? decoder.decode(SkylandersObjectList.self, from: data) {
                    jsonSkylanders = result.Skylanders
//                    print(jsonSkylanders)
                }
                else {
                    print("error in decode Data")
                }
            }
           
        case "Stats":
            if let result = try? decoder.decode(SkylandersStatsList.self, from: data) {
                jsonStats = result.SkylandersStats
//                print(jsonStats)
            }
            else {
                print("error in decode stats")
            }
            
        case "Traps":
            if let result = try? decoder.decode(TrapsDetailsList.self, from: data) {
                jsonTrapDetails = result.TrapsDetails
            }
        
        case "Swappers":
            if let result = try? decoder.decode(SwapperStatsList.self, from: data) {
                jsonSwapperStats = result.SwapperStats
            }
        
        case "SuperChargers":
            if let result = try? decoder.decode(SuperChargersStatsList.self, from: data) {
                jsonSuperChargerStats = result.SuperChargersStats
            }
           
        default: print("Incorrect Data Type")
        }
    }
    
    public static func saveSkylanders() {
        
        parseJson(type: "Data")
        parseJson(type: "Stats")
        parseJson(type: "Traps")
        parseJson(type: "Swappers")
        parseJson(type: "SuperChargers")
        
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
        trapDetail.setValue(jsonTrapDetails.villiansCapturable, forKey: "villiansCapturable")
        
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
    
    static func DeleteData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
    let fetchRequestList = [
        NSFetchRequest<NSManagedObject>(entityName: "Skylander"),
        NSFetchRequest<NSManagedObject>(entityName: "SkylanderStats"),
        NSFetchRequest<NSManagedObject>(entityName: "TrapDetails"),
        NSFetchRequest<NSManagedObject>(entityName: "SwapperStatsTable"),
        NSFetchRequest<NSManagedObject>(entityName: "SuperChargerStatsTable")
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
