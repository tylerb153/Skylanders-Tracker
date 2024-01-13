//
//  VillainsDetailView.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 1/12/24.
//

import UIKit
import CoreData

class VillainsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var villainImage: UIImageView!
    @IBOutlet var villainElementLabel: UILabel!
    @IBOutlet var doomRaiderLabel: UILabel!
    @IBOutlet var trapTable: UITableView!
    
    lazy var villainTrappedBy: [NSManagedObject] = getTraps()
    
    var chosenVillain: NSManagedObject!
    lazy var name = chosenVillain.value(forKey: "name") as! String
    lazy var statsName = chosenVillain.value(forKey: "statsName") as! String
    lazy var variant = chosenVillain.value(forKey: "variantText") as? String ?? ""
    lazy var element = getDetails()?.value(forKey: "element") as? String ?? ""
    
    var trapToSend: NSManagedObject?
    
    override func viewDidLoad() {
        navigationItem.title = name
        SetImage()
        SetLabels()
        
        let cellNib = UINib(nibName: "TrapCell", bundle: nil)
        trapTable.register(cellNib, forCellReuseIdentifier: "TrapCell")
        trapTable.reloadData()
    }
    
//    @IBAction func refresh() {
//        trapTable.reloadData()
////        for i in villainTrappedBy {
////            print("\(i.value(forKey: "statsName") as! String): \(i.value(forKey: "villiansCaptured") as! [String])")
////        }
//    }
    
//MARK: - Helper Functions
    private func SetImage() {
        if let image = ConfigureImage(skylander: chosenVillain) {
            villainImage.image = image
        }
        else {
            villainImage.image = UIImage(systemName: "square")
        }
    }
    
    private func SetLabels() {
        villainElementLabel.text = element
        doomRaiderLabel.text = variant
    }
    
    private func getDetails() -> NSManagedObject? {
        let detailsList = RefreshData(entityName: "VillianDetailsTable")!
//        print(detailsList)
        for i in detailsList {
            if statsName == i.value(forKey: "statsName") as! String {
//                print(i)
                return i
            }
        }
        
        return nil
    }
    private func getTraps() -> [NSManagedObject] {
        guard let trapList = RefreshData(entityName: "TrapDetails") else {
            return []
        }
        var villainsTrappedBy: [NSManagedObject] = []
        for i in trapList {
            if i.value(forKey: "element") as! String == element { //}(i.value(forKey: "villiansCaptured") as! [String]).contains(statsName) {
                villainsTrappedBy.append(i)
            }
        }
//        print(villainsTrappedBy)
        return villainsTrappedBy
    }
}


// MARK: - UITableViewDataSource methods

extension VillainsDetailViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return villainTrappedBy.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var trap: NSManagedObject! {
            let statsName = villainTrappedBy[indexPath.row].value(forKey: "statsName") as! String
            print(statsName)
            guard let skylandersArray = RefreshData(entityName: "Skylander") else {
                return nil
            }
            for skylander in skylandersArray {
                if skylander.value(forKey: "statsName") as! String == statsName {
                    print(skylander)
                    return skylander
                }
            }
            return nil
        }
        
        let cell = configureCell(trap: trap)
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    trapToSend = {
            let statsName = villainTrappedBy[indexPath.row].value(forKey: "statsName") as! String
            guard let skylandersArray = RefreshData(entityName: "Skylander") else {
                print("Error in RefreshingData in VillainsDetailView in accessoryButtonTappedForRowWith")
                return nil
            }
            for skylander in skylandersArray {
                if skylander.value(forKey: "statsName") as! String == statsName {
//                    print(skylander)
                    return skylander
                }
            }
        return nil
    }()
        self.performSegue(withIdentifier: "DisplayTrapPopup", sender: Any?.self)
    }
    
    func configureCell(trap: NSManagedObject) -> UITableViewCell {
        let cellIdentifier = "TrapCell"
        trapTable.rowHeight = 66
        let cell = trapTable.dequeueReusableCell(withIdentifier: cellIdentifier) as! TrapCell
        cell.configure(for: trap, villainDetails: getDetails()!)
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as? UINavigationController
        let TrapsPopupDetailViewController = navigationController?.topViewController as! TrapsPopupDetailViewController
        TrapsPopupDetailViewController.delegate = self
        TrapsPopupDetailViewController.chosenTrap = trapToSend
    }
}

//MARK: - Popup Delegate

extension VillainsDetailViewController: TrapsPopupDelegate {
    func popupDidClose() {
        print("TrapsPopup Closed")
        trapTable.reloadData()
    }
}
