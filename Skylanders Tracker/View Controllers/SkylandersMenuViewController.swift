//
//  SkylandersMenuViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/21/22.
//

import UIKit
import CoreData

class SkylandersMenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    lazy var games = getGames()
    var skylandersList: [NSManagedObject] = []
    lazy var skylandersToDisplay = getSkylandersToDisplay()
    lazy var gamesCount = games.count
    lazy var skylandersCount = skylandersToDisplay.count
    var segmentSelected = 0
    var chosenSkylander: String?
    var chosenGame = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Skylanders Games"
        
        var cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "NothingFoundCell")
        
        cellNib = UINib(nibName: "GameCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "GameCell")
        
        cellNib = UINib(nibName: "SkylanderSelectCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SkylanderSelectCell")
        
        cellNib = UINib(nibName: "SkylanderCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SkylanderCell")
        
        reloadData()
        tableView.reloadData()
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            navigationItem.title = "Skylanders Games"
            segmentSelected = 0
        }
        else {
            navigationItem.title = "Skylanders"
            segmentSelected = 1
        }
        reloadData()
        tableView.reloadData()
    }
    
    // MARK: - Data
    
    func reloadData() {
        skylandersList = RefreshData()!
        skylandersToDisplay = getSkylandersToDisplay()
        skylandersCount = skylandersToDisplay.count
        games = getGames()
        gamesCount = games.count
//        print(skylandersList)
    }
    
    func getGames() -> [String] {
        var gamesList: [String] = []
        for skylander in skylandersList {
            let gameName = skylander.value(forKey: "game") as! String
            if !gamesList.contains(gameName) {
                gamesList.append(gameName)
            }
        }
        return gamesList
    }
    
    func getSkylandersToDisplay() -> [NSManagedObject] {
        var skylandersToDisplay: [NSManagedObject] = []
        var skylandersBaseNames: [String] = []
        for skylander in skylandersList {
            let baseName = skylander.value(forKey: "baseName") as! String
            if !skylandersBaseNames.contains(baseName) {
                skylandersBaseNames.append(baseName)
                skylandersToDisplay.append(skylander)
            }
        }
        return skylandersToDisplay
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChoseSkylander" {
            
            let SkylandersListViewController = segue.destination as! SkylandersListTableViewController
            SkylandersListViewController.skylandersList = skylandersList
            SkylandersListViewController.chosenSkylander = chosenSkylander
        }
        if segue.identifier == "ChoseGame" {
            let SkylandersListViewController = segue.destination as! SkylandersListTableViewController
            SkylandersListViewController.skylandersList = skylandersList
            SkylandersListViewController.chosenGame = chosenGame
        }
    }
}

// MARK: - tableView Delegate
extension SkylandersMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return gamesCount
        }
        else {
            return skylandersCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentSelected == 0 {
            let cellIdentifier = "GameCell"
            tableView.rowHeight = 80
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! GameCell
            let gameName = games[indexPath.row]
            cell.configure(gameName: gameName)
            return cell
        }
        else {
            let cellIdentifier = "SkylanderSelectCell"
            tableView.rowHeight = 66
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SkylanderSelectCell
            cell.configure(for: skylandersToDisplay[indexPath.row])
            cell.updateCheckmark(checked: checkedOff(index: indexPath.row))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentSelected == 1 {
            chosenSkylander = skylandersToDisplay[indexPath.row].value(forKey: "baseName") as? String
            self.performSegue(withIdentifier: "ChoseSkylander", sender: Any?.self)
        }
        else {
            chosenGame = games[indexPath.row]
            self.performSegue(withIdentifier: "ChoseGame", sender: Any?.self)
        }
    }
    
    private func checkedOff(index: Int) -> Bool {
        let skylanderToCheckName = skylandersToDisplay[index].value(forKey: "baseName") as! String
        for skylander in skylandersList {
            if skylander.value(forKey: "baseName") as! String == skylanderToCheckName {
                if skylander.value(forKey: "isChecked") as! Bool && skylander.value(forKey: "variantText") as! String != "Sidekick" {
                    return true
                }
            }
        }
        return false
    }
}
// MARK: - Data Save
extension SkylandersMenuViewController {
    
    @IBAction func deleteData() {
        reloadData()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        for i in skylandersList {
            managedContext.delete(i)
        }
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        reloadData()
        tableView.reloadData()
        
    }
    
    @IBAction func runJsonParse() {
        print("running")
        DataBuilder.saveSkylanders()
        reloadData()
        tableView.reloadData()
    }
    
//    @IBAction func addFakeData() {
//        print("added data")
//        saveSkylander()
//        refreshData()
//        tableView.reloadData()
//    }
    
//    func saveSkylander() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Skylander", in: managedContext)!
//        let skylander = NSManagedObject(entity: entity, insertInto: managedContext)
//        skylander.setValue("Bash", forKey: "name")
//        skylander.setValue("Bash", forKey: "baseName")
//        skylander.setValue(1, forKey: "series")
//        skylander.setValue(false, forKey: "isChecked")
//        skylander.setValue("", forKey: "variantText")
//        skylander.setValue("Spyro's Adventure", forKey: "game")
//        skylander.setValue("Bash", forKey: "statsName")
////        skylander.setValue("Giants", forKey: "game")
////        skylander.setValue("Swap Force", forKey: "game")
////        skylander.setValue("Trap Team", forKey: "game")
////        skylander.setValue("SuperChargers", forKey: "game")
//
//        do {
//            try managedContext.save()
//            skylandersList.append(skylander)
//            refreshData()
//            tableView.reloadData()
//        }
//        catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
}
