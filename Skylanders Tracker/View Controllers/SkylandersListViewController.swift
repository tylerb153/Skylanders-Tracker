//
//  SkylandersListViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/21/22.
//

import UIKit
import CoreData

class SkylandersListTableViewController: UITableViewController {

    //MARK: - Variables
    @IBOutlet weak var searchBar: UISearchBar!
    
    var skylandersList: [NSManagedObject] = []
    var skylandersToDisplay: [NSManagedObject]{getSkylandersToDisplay()}
    var skylandersCount: Int{skylandersToDisplay.count}
    var sectionsToDisplay: [String] {getSections()}
    var chosenSkylander: String?
    var chosenGame: String?
    var skylanderToSend: NSManagedObject?
    var searchText: String = ""
    var nothingFound = false
    
    //MARK: - View did appear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skylandersList = RefreshData(entityName: "Skylander")!
        if let chosenSkylander = chosenSkylander {
            navigationItem.title = chosenSkylander
        }
        if let chosenGame = chosenGame {
            navigationItem.title = chosenGame
        }
        
        let searchBarHeight = searchBar.frame.size.height
        tableView.setContentOffset(CGPoint(x: 0, y: searchBarHeight), animated: false)
        
        var cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "NothingFoundCell")
        
        cellNib = UINib(nibName: "GameCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "GameCell")
        
        cellNib = UINib(nibName: "SkylanderSelectCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SkylanderSelectCell")
        
        cellNib = UINib(nibName: "SkylanderCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SkylanderCell")
        
        tableView.reloadData()
    }
    
    // MARK: - Data Processing
    func getSkylandersToDisplay() -> [NSManagedObject] {
        var skylandersToDisplay: [NSManagedObject] = []
        if let chosenSkylander = chosenSkylander {
            for skylander in skylandersList {
                let skylanderBaseName = skylander.value(forKey: "baseName") as! String
                if skylanderBaseName == chosenSkylander {
                    let skylanderName = skylander.value(forKey: "name") as! String
                    if searchText != ""{
                        if skylanderName.uppercased().contains(searchText.uppercased()) {
                            skylandersToDisplay.append(skylander)
                        }
                    }
                    else {
                        skylandersToDisplay.append(skylander)
                    }
                }
            }
        }
        else {
            for skylander in skylandersList {
                let skylanderGame = skylander.value(forKey: "game") as! String
                if skylanderGame == chosenGame {
                    let skylanderName = skylander.value(forKey: "name") as! String
                    if searchText != ""{
                        if skylanderName.uppercased().contains(searchText.uppercased()) {
                            skylandersToDisplay.append(skylander)
                        }
                    }
                    else {
                        skylandersToDisplay.append(skylander)
                    }
                }
            }
        }
        return skylandersToDisplay
    }
    
    private func getSections() -> [String] {
        var sectionsToDisplay: [String] = []
        
        for skylander in skylandersToDisplay {
            let variant = skylander.value(forKey: "variantText") as! String
            if !sectionsToDisplay.contains(variant) {
                sectionsToDisplay.append(variant)
            }
        }
//        print(sectionsToDisplay)
        return sectionsToDisplay
    }
    
    private func getSkylandersSection(variantText: String) -> [NSManagedObject] {
        var sectionSkylanders: [NSManagedObject] = []
        for skylander in skylandersToDisplay {
            if skylander.value(forKey: "variantText") as! String == variantText {
                sectionSkylanders.append(skylander)
            }
        }
        
        return sectionSkylanders
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "DisplaySkylander":
            let SkylandersDetailViewController = segue.destination as! SkylandersDetailViewController
            SkylandersDetailViewController.chosenSkylander = skylanderToSend
        case "DisplayTrap":
            let TrapsDetailViewController = segue.destination as! TrapsDetailViewController
            TrapsDetailViewController.chosenTrap = skylanderToSend
        case "DisplaySwapper":
            let SwappersDetailViewController = segue.destination as! SwappersDetailViewController
            SwappersDetailViewController.chosenSwapper = skylanderToSend
        case "DisplaySuperCharger":
//            print(skylanderToSend)
            let SuperChargersDetailViewController = segue.destination as! SuperChargersDetailViewController
            SuperChargersDetailViewController.chosenSuperCharger = skylanderToSend
        case "DisplaySensei":
            let SenseisDetailViewController = segue.destination as! SenseisDetailViewController
            SenseisDetailViewController.chosenSensei = skylanderToSend
        case "DisplayVillain":
            let VillainsDetailViewController = segue.destination as! VillainsDetailViewController
            VillainsDetailViewController.chosenVillain = skylanderToSend
        default:
            print("Error in send")
        }
//        if segue.identifier == "DisplaySkylander" {
//            let SkylandersDetailViewController = segue.destination as! SkylandersDetailViewController
//            SkylandersDetailViewController.chosenSkylander = skylanderToSend
//        }
    }
}

// MARK: - Table View Delegate
extension SkylandersListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if skylandersCount == 0 {
//            print("Nothing Found")
            nothingFound = true
            return 1
        }
        nothingFound = false
        return sectionsToDisplay.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection sectionNumber: Int) -> String? {
        if nothingFound {
            return ""
        }
        var modifiedSectionsToDisplay: [String] = []
        for section in sectionsToDisplay {
            switch section {
            case "": modifiedSectionsToDisplay.append("Skylanders")
            default: modifiedSectionsToDisplay.append(section + "s")
            }
        }
        
        return modifiedSectionsToDisplay[sectionNumber]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(skylandersCount)
        if skylandersCount == 0 {
//            print("Nothing Found")
            nothingFound = true
            return 1
        }
        nothingFound = false
        return getSkylandersSection(variantText: sectionsToDisplay[section]).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if nothingFound == true {
            let cellIdentifier = "NothingFoundCell"
            tableView.rowHeight = 44
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
            return cell
        }
        
        let cell = configureCell(variantText: sectionsToDisplay[indexPath.section], row: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !nothingFound {
            skylanderToSend = getSkylandersSection(variantText: sectionsToDisplay[indexPath.section])[indexPath.row]
            var type = skylanderToSend?.value(forKey: "variantText") as! String
            if (type.contains("Swapper")) {
                type = "Swapper"
            }
            else if (type.contains("Trap") && !type.contains("Trap Master")) {
                type = "Trap"
            }
            else if (type.contains("SuperCharger")) {
                type = "SuperCharger"
            }
            else if (type.contains("Sensei")) {
                type = "Sensei"
            }
            else if (type.contains("Villian") || type.contains("Doom Raider")) {
                type = "Villain"
            }

            switch type {
            case "Trap":
                self.performSegue(withIdentifier: "DisplayTrap", sender: Any?.self)
            case "Swapper":
                self.performSegue(withIdentifier: "DisplaySwapper", sender: Any?.self)
            case "SuperCharger":
                self.performSegue(withIdentifier: "DisplaySuperCharger", sender: Any?.self)
            case "Sensei":
                self.performSegue(withIdentifier: "DisplaySensei", sender: Any?.self)
            case "Villain":
                self.performSegue(withIdentifier: "DisplayVillain", sender: Any?.self)
            default:
                self.performSegue(withIdentifier: "DisplaySkylander", sender: Any?.self)
            }
            tableView.deselectRow(at: indexPath, animated: true)
            
            //Implemented until detail page is made correctly
//            let checked = skylanderToSend?.value(forKey: "isChecked") as! Bool
//            if checked {
//                skylanderToSend?.setValue(false, forKey: "isChecked")
//            }
//            else {
//                skylanderToSend?.setValue(true, forKey: "isChecked")
//            }
            tableView.reloadData()
        }
    }
    
    func configureCell(variantText: String, row: Int) -> UITableViewCell {
        let cellIdentifier = "SkylanderCell"
        tableView.rowHeight = 66
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SkylanderCell
        cell.configure(for: getSkylandersSection(variantText: variantText)[row])
        return cell
    }
}

//MARK: Search Bar Delegate
extension SkylandersListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
//        print(self.searchText)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
}
