//
//  DeleteAccountViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 10/11/23.
//

import UIKit

class DeleteAccountViewController: UIViewController {

    private let deleteAccountView = DeleteAccountView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Delete Account"
        
        deleteAccountView.delegate = self
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: deleteAccountView.backButton)
        
        view = deleteAccountView
    }
}

extension DeleteAccountViewController: DeleteAccountViewDelegate {
    func dismiss() {
        dismiss(animated: true)
    }
}
