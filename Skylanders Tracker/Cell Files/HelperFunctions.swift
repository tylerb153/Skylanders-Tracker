//
//  HelperFunctions.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 8/30/22.
//

import CoreData
import UIKit

//MARK: - Config Skylanders
func ConfigureImage(skylander: NSManagedObject) -> UIImage? {
    
    let skylanderName = configureName(name: skylander.value(forKey: "name") as! String, series: skylander.value(forKey: "series") as! Int, variant: skylander.value(forKey: "variantText") as! String)
    return UIImage(named: skylanderName)
    
}

private func configureName(name: String, series: Int, variant: String) -> String {
    if series == 0 {
        if variant == "Villians" || variant == "Doom Raiders" || variant == "Villian Variants" {
            return "\(name)V"
        }
        else {
            return "\(name)1"
        }
    }
    else {
        return "\(name)\(series)"
    }
}
    
//MARK: - Data Functions
func RefreshData() -> [NSManagedObject]? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        print("Error in RefreshData()")
        return nil
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Skylander")
    do {
        return try managedContext.fetch(fetchRequest)
    }
    catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
//        print(skylandersList)
    print("Error in RefreshData()")
    return nil
}

