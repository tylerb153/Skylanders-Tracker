//
//  SuperChargersPopupDetailViewController.swift
//  Skylanders Tracker
//
//  Created by Tyler Bischoff on 1/14/24.
//


class SuperChargersPopupDetailViewController: SuperChargersDetailViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vehicleButton.isHidden = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
