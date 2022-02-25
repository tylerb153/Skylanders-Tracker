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
    lazy var skylandersCount = skylandersList.count
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
        navigationItem.title = skylandersList[0].value(forKey: "name") as? String
        
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
        skylandersCount = skylandersList.count
//        print(skylandersList)
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
        cell.configure(for: skylandersList[indexPath.row])
        return cell
    }
}
