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
    lazy var gamesCount = games.count
    lazy var skylandersCount = skylandersList.count
    var segmentSelected = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
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
        
        refreshData()
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
        refreshData()
        tableView.reloadData()
    }
    
    // MARK: - Data
    
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
        skylandersCount = skylandersList.count
        games = getGames()
        gamesCount = games.count
//        print(skylandersList)
    }
    
    func getGames() -> [String] {
        var gamesList: [String] = []
        for i in skylandersList {
            let gameName = i.value(forKey: "game") as! String
            if(!gamesList.contains(gameName)) {
                gamesList.append(gameName)
            }
        }
        return gamesList
    }
}

// MARK: - tableView Delegate
extension SkylandersMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return games.count
        }
        else {
            print(skylandersCount)
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
            cell.configure(for: skylandersList[indexPath.row])
            return cell
        }
    }
}
// MARK: - Data Save
extension SkylandersMenuViewController {
    @IBAction func addFakeData() {
        print("added data")
        saveSkylander()
        refreshData()
        tableView.reloadData()
    }
    
    func saveSkylander() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Skylander", in: managedContext)!
        let skylander = NSManagedObject(entity: entity, insertInto: managedContext)
        skylander.setValue("Sonic Boom", forKey: "name")
        skylander.setValue(1, forKey: "series")
        skylander.setValue(false, forKey: "isChecked")
        skylander.setValue("Giants", forKey: "game")
//        skylander.setValue("Spyro's Adventure", forKey: "game")
        
        do {
            try managedContext.save()
            skylandersList.append(skylander)
            tableView.reloadData()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
