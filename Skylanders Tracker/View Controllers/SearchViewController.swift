//
//  SearchViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/21/22.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var skylandersList: [NSManagedObject] = []
    var skylandersToDisplay: [NSManagedObject]{ getSkylandersToDisplay()}
    var skylandersCount: Int{skylandersToDisplay.count}
    
    var skylanderToSend: NSManagedObject?
    var searchText: String = ""
    var nothingFound = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
        refreshData()
//        print(skylandersList)
//        print(skylandersCount)
        
        var cellNib = UINib(nibName: "SkylanderCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SkylanderCell")
        
        cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "NothingFoundCell")
        
        tableView.reloadData()
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplaySkylander" {
            let SkylandersDetailViewController = segue.destination as! SkylandersDetailViewController
            SkylandersDetailViewController.chosenSkylander = skylanderToSend
        }
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
//        print(skylandersList)
    }
    
    func getSkylandersToDisplay() -> [NSManagedObject] {
        var skylandersToDisplay: [NSManagedObject] = []
        for skylander in skylandersList{
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
//        print(skylandersToDisplay)
        return skylandersToDisplay
    }
}

// MARK: - tableView Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(skylandersCount)
        if skylandersCount == 0 {
//            print("Nothing Found")
            nothingFound = true
            return 1
        }
        nothingFound = false
        return skylandersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if nothingFound == true {
            let cellIdentifier = "NothingFoundCell"
            tableView.rowHeight = 44
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
            return cell
        }
        
        
        let cellIdentifier = "SkylanderCell"
        tableView.rowHeight = 66
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SkylanderCell
        cell.configure(for: skylandersToDisplay[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !nothingFound {
            skylanderToSend = skylandersToDisplay[indexPath.row]
//            self.performSegue(withIdentifier: "DisplaySkylander", sender: Any?.self)
            tableView.deselectRow(at: indexPath, animated: true)
            
            //Implemented until detail page is finished
            let checked = skylanderToSend?.value(forKey: "isChecked") as! Bool
            if checked {
                skylanderToSend?.setValue(false, forKey: "isChecked")
            }
            else {
                skylanderToSend?.setValue(true, forKey: "isChecked")
            }
            tableView.reloadData()
            

        }
    }
}

//MARK: Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
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
