//
//  TrapsPopupDetailViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 1/12/24.
//

import UIKit

protocol TrapsPopupDelegate: AnyObject {
    func popupDidClose()
}

class TrapsPopupDetailViewController: TrapsDetailViewController {
    
    weak var delegate: TrapsPopupDelegate?
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        }
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.popupDidClose()
    }
}
