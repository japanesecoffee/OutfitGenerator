//
//  PasswordSettingsViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 10/11/23.
//

import UIKit

class PasswordSettingsViewController: UIViewController {

    private let passwordSettingsView = PasswordSettingsView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Password"
        
        passwordSettingsView.delegate = self
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: passwordSettingsView.backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: passwordSettingsView.saveButton)
        
        view = passwordSettingsView
    }
}

extension PasswordSettingsViewController: PasswordSettingsViewDelegate {
    func dismiss() {
        dismiss(animated: true)
    }
}
