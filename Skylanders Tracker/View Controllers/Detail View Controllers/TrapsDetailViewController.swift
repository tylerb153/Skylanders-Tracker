//
//  TrapsDetailViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 8/29/22.
//

import UIKit
import CoreData

class TrapsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var trapImage: UIImageView!
    @IBOutlet var trapElementLabel: UILabel!
    @IBOutlet var trapDesignLabel: UILabel!
    @IBOutlet var villainTable: UITableView!
    
    lazy var villainsTrapable: [NSManagedObject] = getVillainsTrapable()
    
    var chosenTrap: NSManagedObject!
    lazy var name = chosenTrap.value(forKey: "name") as! String
    lazy var statsName = chosenTrap.value(forKey: "statsName") as! String
    lazy var element = getDetails()?.value(forKey: "element") as? String ?? ""
    
    var villainToSend: NSManagedObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = name
        SetImage()
        SetLabels()
        
        let cellNib = UINib(nibName: "VillainCell", bundle: nil)
        villainTable.register(cellNib, forCellReuseIdentifier: "VillainCell")
        villainTable.reloadData()
    }
    
//MARK: - Helper Functions
    private func SetImage() {
        if let image = ConfigureImage(skylander: chosenTrap) {
            trapImage.image = image
        }
        else {
            trapImage.image = UIImage(systemName: "square")
        }
    }
    
    private func SetLabels() {
        let trapDetails = getDetails()
//        print(trapDetails)
        if trapDetails != nil {
            trapElementLabel.text = element
            trapDesignLabel.text = trapDetails!.value(forKey: "design") as? String
        }
        else {
            trapElementLabel.text = ""
            trapDesignLabel.text = ""
        }
        
    }
    
    private func getDetails() -> NSManagedObject? {
        let detailsList = RefreshData(entityName: "TrapDetails")!
//        print(detailsList)
        for i in detailsList {
            if statsName == i.value(forKey: "statsName") as! String {
//                print(i)
                return i
            }
        }
        
        return nil
    }
    private func getVillainsTrapable() -> [NSManagedObject] {
        guard let villainList = RefreshData(entityName: "VillianDetailsTable") else {
            return []
        }
//        print(villainList)
        var villainsTrapable: [NSManagedObject] = []
        for i in villainList {
//            print(i)
            if element == i.value(forKey: "element") as! String {
                let villainSpecialTrap = i.value(forKey: "specialTrap") as! String
                if villainSpecialTrap == "" {
                    villainsTrapable.append(i)
                }
                else if villainSpecialTrap == statsName {
                    villainsTrapable.append(i)
                }
            }
        }
//        print(villainsTrapable)
        return villainsTrapable
    }
}


// MARK: - UITableViewDataSource methods

extension TrapsDetailViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return villainsTrapable.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let skylandersList:[NSManagedObject] = RefreshData(entityName: "Skylander") ?? []
        let villainStatsName = villainsTrapable[indexPath.row].value(forKey: "statsName") as! String
        for i in skylandersList {
            if villainStatsName == i.value(forKey:"statsName") as! String {
                villainToSend = i
                self.performSegue(withIdentifier: "DisplayVillainPopup", sender: Any?.self)
                return
            }
        }
    }
    
    func configureCell(villain: NSManagedObject) -> UITableViewCell {
        let cellIdentifier = "VillainCell"
        villainTable.rowHeight = 66
        let cell = villainTable.dequeueReusableCell(withIdentifier: cellIdentifier) as! VillainCell
        cell.configure(for: villain, chosenTrap: getDetails())
        return cell
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as? UINavigationController
        let VillainsPopupDetailViewController = navigationController?.topViewController as! VillainsPopupDetailViewController
        VillainsPopupDetailViewController.delegate = self
        VillainsPopupDetailViewController.chosenVillain = villainToSend
    }
}

//MARK: - Popup Delegate

extension TrapsDetailViewController: VillainsPopupDelegate {
    func popupDidClose() {
        villainTable.reloadData()
    }
}
