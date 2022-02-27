//
//  SkylandersDetailViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/21/22.
//

import UIKit
import CoreData

class SkylandersDetailViewController: UIViewController {
    
    //Label names changed only with SuperChargers and Imaginators
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var armorLabel: UILabel!
    @IBOutlet weak var criticalHitLabel: UILabel!
    @IBOutlet weak var elementalPowerLabel: UILabel!
    @IBOutlet weak var startHealthLabel: UILabel!
    @IBOutlet weak var maximumHealthLabel: UILabel!

    //The values to the names above
    @IBOutlet weak var skylanderSpeed: UILabel!
    @IBOutlet weak var skylanderArmor: UILabel!
    @IBOutlet weak var skylanderCriticalHit: UILabel!
    @IBOutlet weak var skylanderElementalPower: UILabel!
    @IBOutlet weak var skylanderStartHealth: UILabel!
    @IBOutlet weak var skylanderMaximumHealth: UILabel!
    
    //Other properties
    @IBOutlet weak var skylanderImage: UIImageView!
    @IBOutlet weak var compatableGames: UILabel!
    @IBOutlet weak var skylanderSeries: UILabel!
    @IBOutlet weak var skylanderGame: UILabel!
    
    var chosenSkylander: NSManagedObject?
    lazy var name = chosenSkylander!.value(forKey: "name") as! String
    lazy var baseName = chosenSkylander!.value(forKey: "baseName") as! String
    lazy var series = chosenSkylander!.value(forKey: "series") as! Int
    lazy var image = getImage()
    lazy var game = chosenSkylander!.value(forKey: "game") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        skylanderSeries.text = configureSeries()
        skylanderImage.image = image
        skylanderGame.text = game
        tintGame()
    }
    
    // MARK: - Helper Functions
    func getImage() -> UIImage {
        if let image = UIImage(named: configureName(name: name, series: series)) {
            return image
        }
        else {
            return UIImage(systemName: "square")!
        }
    }
    
    private func configureName(name: String, series: Int) -> String {
//        return "\(name)1"
        if series == 0 {
            return "\(name)1"
        }
        else {
            return "\(name)\(series)"
        }
    }
    
    func configureSeries() -> String {
        if series == 0 {
            let varient = chosenSkylander?.value(forKey: "varientText") as! String
            return varient
        }
        else {
            return "Series \(series)"
        }
    }
    
    func tintGame() {
        let game = "Spyro's Adventure"
        let color = UIColor(named: game)
        
        skylanderGame.backgroundColor = color
    }
}
