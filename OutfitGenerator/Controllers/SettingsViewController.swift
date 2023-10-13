//
//  SettingsViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 10/6/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let backButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(
            systemName: "chevron.left",
            withConfiguration: configuration
        )?.withTintColor(
            .systemGreen,
            renderingMode: .alwaysOriginal
        )
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.setTitle(" Back", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.sizeToFit()
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let settingOptions = ["Email", "Password", "Delete Account", "Sign Out"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settingOptions[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController: UIViewController
        
        if indexPath.row == 0 {
            viewController = EmailSettingsViewController()
        } else if indexPath.row == 1 {
            viewController = PasswordSettingsViewController()
        } else if indexPath.row == 2 {
            viewController = DeleteAccountViewController()
        } else {
            let alert = UIAlertController(
                title: "Sign Out",
                message: "Are you sure you want to sign out?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                alert.dismiss(animated: true)
            })
            alert.addAction(UIAlertAction(title: "Sign Out", style: .default) { (action) in
                print("signed out")
            })
            
            present(alert, animated: true)
            
            return
        }
        
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
