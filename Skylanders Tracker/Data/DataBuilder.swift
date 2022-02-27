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
    
    // MARK: - JSON parse
    private static func getData(type dataType: String) -> Data? {
        var name = ""
        if dataType == "Data" {
            name = "Skylanders Data"
        }
        else {
            name = "Skylanders Stats"
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
        guard let data = getData(type: dataType) else {print("error"); return}
        
        let decoder = JSONDecoder()
        switch dataType {
        case "Data":
            if dataType == "Data" {
                if let result = try? decoder.decode(SkylandersObjectList.self, from: data) {
                    jsonSkylanders = result.Skylanders
//                    print(jsonSkylanders)
                }
                else {
                    print("error")
                }
            }
           
        case "Stats":
            if let result = try? decoder.decode(SkylandersStatsList.self, from: data) {
                jsonStats = result.SkylandersStats
//                print(jsonStats)
            }
            else {
                print("error")
            }
           
        default: print("Incorrect Data Types")
        }
    }
    
    public static func saveSkylanders() {
        
        parseJson(type: "Data")
        parseJson(type: "Stats")
        for jsonSkylander in jsonSkylanders {
            saveSkylander(jsonSkylander: jsonSkylander)
        }
        for jsonStat in jsonStats {
            saveStats(jsonStats: jsonStat)
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
        skylander.setValue(jsonSkylander.varientText, forKey: "varientText")
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
}
