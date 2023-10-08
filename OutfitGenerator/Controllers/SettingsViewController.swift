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
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var settingOptions = ["account info", "delete account", "sign out"]

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
        tableView.frame = view.frame
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
        let option = settingOptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = option
        return cell
    }
}
