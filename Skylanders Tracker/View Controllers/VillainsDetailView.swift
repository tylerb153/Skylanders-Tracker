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
    
    lazy var villainTrappedIn: [NSManagedObject] = getTraps()
    
    var chosenVillain: NSManagedObject!
    lazy var name = chosenVillain.value(forKey: "name") as! String
    lazy var statsName = chosenVillain.value(forKey: "statsName") as! String
    lazy var variant = chosenVillain.value(forKey: "variantText") as? String ?? ""
    lazy var element = getDetails()?.value(forKey: "element") as? String ?? ""
    
    
    override func viewDidLoad() {
        navigationItem.title = name
        SetImage()
        SetLabels()
        
        let cellNib = UINib(nibName: "TrapCell", bundle: nil)
        trapTable.register(cellNib, forCellReuseIdentifier: "TrapCell")
        trapTable.reloadData()
    }
    
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
        var villainsTrappedIn: [NSManagedObject] = []
        for i in trapList {
            if i.value(forKey: "element") as! String == element { //}(i.value(forKey: "villiansCaptured") as! [String]).contains(statsName) {
                villainsTrappedIn.append(i)
            }
        }
        return villainsTrappedIn
    }
}


// MARK: - UITableViewDataSource methods

extension VillainsDetailViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return villainTrappedIn.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var villain: NSManagedObject! {
            let statsName = villainTrappedIn[indexPath.row].value(forKey: "statsName") as! String
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
        
        let cell = configureCell(trap: villain)
        return cell
    }
    
    func configureCell(trap: NSManagedObject) -> UITableViewCell {
        let cellIdentifier = "TrapCell"
        trapTable.rowHeight = 66
        let cell = trapTable.dequeueReusableCell(withIdentifier: cellIdentifier) as! TrapCell
        cell.configure(for: trap, villainDetails: getDetails()!)
        return cell
    }
}
