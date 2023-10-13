//
//  EmailSettingsViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 10/10/23.
//

import UIKit

class EmailSettingsViewController: UIViewController {
    
    private let emailSettingsView = EmailSettingsView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Email"
        
        emailSettingsView.delegate = self
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emailSettingsView.backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: emailSettingsView.saveButton)
        
        view = emailSettingsView
    }
}

extension EmailSettingsViewController: EmailSettingsViewDelegate {
    func dismiss() {
        dismiss(animated: true)
    }
}
