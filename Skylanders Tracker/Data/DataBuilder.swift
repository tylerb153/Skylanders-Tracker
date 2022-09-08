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
    private static var jsonTrapDetails: [TrapsDetails] = []
    
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
           
        default: print("Incorrect Data Type")
        }
    }
    
    public static func saveSkylanders() {
        
        parseJson(type: "Data")
        parseJson(type: "Stats")
        parseJson(type: "Traps")
        for jsonSkylander in jsonSkylanders {
            saveSkylander(jsonSkylander: jsonSkylander)
        }
        for jsonStat in jsonStats {
            saveStats(jsonStats: jsonStat)
        }
        for jsonTrapDetail in jsonTrapDetails {
            saveTrapDetails(jsonTrapDetails: jsonTrapDetail)
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
    
    static func DeleteData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
    let fetchRequestList = [
        NSFetchRequest<NSManagedObject>(entityName: "Skylander"),
        NSFetchRequest<NSManagedObject>(entityName: "SkylanderStats"),
        NSFetchRequest<NSManagedObject>(entityName: "TrapDetails")
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
