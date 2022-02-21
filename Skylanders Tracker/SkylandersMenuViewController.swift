//
//  SkylandersMenuViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/21/22.
//

import UIKit

class SkylandersMenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let gamesCount = 6
    let skylandersCount = 300
    var segmentSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Skylanders Games"
        
        var cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "NothingFoundCell")
        
        cellNib = UINib(nibName: "GameCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "GameCell")
        
        cellNib = UINib(nibName: "SkylanderCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SkylanderCell")
        
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
        tableView.reloadData()
    }
}

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
            let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! GameCell
            return cell
        }
        else {
            let cellIdentifier = "SkylanderCell"
            tableView.rowHeight = 66
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SkylanderCell
            cell.accessoryType = .none
            cell.setName(givenName: "Test Name")
            cell.setSeries(givenSeries: "")
            return cell
        }
    }
}
