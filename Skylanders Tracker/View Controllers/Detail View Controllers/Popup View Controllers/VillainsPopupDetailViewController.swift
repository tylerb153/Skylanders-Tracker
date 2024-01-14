//
//  VillainsPopupDetailViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 1/13/24.
//

import UIKit
import CoreData

protocol VillainsPopupDelegate: AnyObject {
    func popupDidClose()
}

class VillainsPopupDetailViewController: VillainsDetailViewController {
    
    weak var delegate: VillainsPopupDelegate?
    
    override func viewDidLoad() {
            super.viewDidLoad()
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.popupDidClose()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var trap: NSManagedObject! {
            let statsName = villainTrappedBy[indexPath.row].value(forKey: "statsName") as! String
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
        
        let cell = configureCell(trap: trap)
        cell.accessoryType = .none
        return cell
    }
}
