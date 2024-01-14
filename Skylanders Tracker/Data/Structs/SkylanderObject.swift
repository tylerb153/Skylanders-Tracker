//
//  Skylanders.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 2/27/22.
//

import Foundation

struct SkylanderObject: Codable {
    var name = ""
    var game = ""
    var series = -1
    var baseName = ""
    var isChecked = false
    var variantText = ""
    var statsName = ""
    var worksWithSpyrosAdventure = false
    var worksWithGiants = false
    var worksWithSwapForce = false
    var worksWithTrapTeam = false
    var worksWithSuperChargers = false
    var worksWithImaginators = false
}
