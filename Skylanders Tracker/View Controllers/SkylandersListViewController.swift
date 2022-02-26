//
//  SkylandersListViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/21/22.
//

import UIKit
import CoreData

class SkylandersListTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var skylandersList: [NSManagedObject] = []
    lazy var skylandersToDisplay: [NSManagedObject] = getSkylandersToDisplay()
    lazy var skylandersCount = skylandersToDisplay.count
    var chosenSkylander: String?
    var chosenGame: String?
    var skylanderToSend: NSManagedObject?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
        if let chosenSkylander = chosenSkylander {
            navigationItem.title = chosenSkylander
            searchBar.placeholder = "Search for a series"
        }
        if let chosenGame = chosenGame {
            navigationItem.title = chosenGame
            searchBar.placeholder = "Search for a Skylander"
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
    
    // MARK: Actions
    
    
    // MARK: - Data Refresh
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplaySkylander" {
            let SkylandersDetailViewController = segue.destination as! SkylandersDetailViewController
            SkylandersDetailViewController.chosenSkylander = skylanderToSend
        }
    }
}

extension SkylandersListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skylandersCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "SkylanderCell"
        tableView.rowHeight = 66
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SkylanderCell
        cell.configure(for: skylandersToDisplay[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        skylanderToSend = skylandersToDisplay[indexPath.row]
        self.performSegue(withIdentifier: "DisplaySkylander", sender: Any?.self)
    }
}
