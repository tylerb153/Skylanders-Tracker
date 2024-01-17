//
//  TrapsPopupDetailViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 1/12/24.
//

import UIKit
import CoreData

protocol TrapsPopupDelegate: AnyObject {
    func popupDidClose()
}

class TrapsPopupDetailViewController: TrapsDetailViewController {
    
    weak var popupDelegate: TrapsPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.popupDelegate?.popupDidClose()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var villain: NSManagedObject! {
            let statsName = villainsTrapable[indexPath.row].value(forKey: "statsName") as! String
            guard let skylandersArray = RefreshData(entityName: "Skylander") else {
                return nil
            }
            for skylander in skylandersArray {
                if skylander.value(forKey: "statsName") as! String == statsName {
//                    print(skylander)
                    return skylander
                }
            }
            return nil
        }
        
        let cell = configureCell(villain: villain)
        cell.accessoryType = .none
        return cell
    }
}
