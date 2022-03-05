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
    lazy var skylandersToDisplay: [NSManagedObject] = getSkylandersToDisplay()
    lazy var skylandersCount = skylandersToDisplay.count
    lazy var sectionsToDisplay: [String] = getSections()
    var chosenSkylander: String?
    var chosenGame: String?
    var skylanderToSend: NSManagedObject?
    
    //MARK: - View did/will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
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
    func refreshData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Skylander")
        do {
            skylandersList = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        skylandersCount = skylandersToDisplay.count
        sectionsToDisplay = getSections()
//        print(skylandersList)
    }
    
    func getSkylandersToDisplay() -> [NSManagedObject] {
        var skylandersToDisplay: [NSManagedObject] = []
        if let chosenSkylander = chosenSkylander {
            for skylander in skylandersList {
                let skylanderBaseName = skylander.value(forKey: "baseName") as! String
                if skylanderBaseName == chosenSkylander {
                    skylandersToDisplay.append(skylander)
                }
            }
        }
        else {
            for skylander in skylandersList {
                let skylanderGame = skylander.value(forKey: "game") as! String
                if skylanderGame == chosenGame {
                    skylandersToDisplay.append(skylander)
                }
            }
        }
        return skylandersToDisplay
    }
    
    
    private func getSections() -> [String] {
        var sectionsToDisplay: [String] = []
        
        for skylander in skylandersToDisplay {
            var varient = skylander.value(forKey: "varientText") as! String
            if varient == "" {
                varient = "Skylanders"
            }
            if !sectionsToDisplay.contains(varient) {
                sectionsToDisplay.append(varient)
            }
        }
        if let index = sectionsToDisplay.firstIndex(of: "") {
            sectionsToDisplay.remove(at: index)
        }
        print(sectionsToDisplay)
        return sectionsToDisplay
    }
    
    private func getSkylandersSection(varientText: String) -> [NSManagedObject] {
        var sectionSkylanders: [NSManagedObject] = []
        var ModifiedVarientText = varientText
        if varientText == "Skylanders" {
            ModifiedVarientText = ""
        }
        
        for skylander in skylandersToDisplay {
            if skylander.value(forKey: "varientText") as! String == ModifiedVarientText {
                sectionSkylanders.append(skylander)
            }
        }
        
        return sectionSkylanders
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplaySkylander" {
            let SkylandersDetailViewController = segue.destination as! SkylandersDetailViewController
            SkylandersDetailViewController.chosenSkylander = skylanderToSend
        }
    }
}

extension SkylandersListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsToDisplay.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsToDisplay[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSkylandersSection(varientText: sectionsToDisplay[section]).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = configureCell(varientText: sectionsToDisplay[indexPath.section], row: indexPath.row)
            return cell
            }
        return tableView.dequeueReusableCell(withIdentifier: "NothingFoundCell")!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        skylanderToSend = skylandersToDisplay[indexPath.row]
        self.performSegue(withIdentifier: "DisplaySkylander", sender: Any?.self)
    }
    
    func configureCell(varientText: String, row: Int) -> UITableViewCell {
        let cellIdentifier = "SkylanderCell"
        tableView.rowHeight = 66
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SkylanderCell
        cell.configure(for: getSkylandersSection(varientText: varientText)[row])
        return cell
    }
}
