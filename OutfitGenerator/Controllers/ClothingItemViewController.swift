//
//  ClothingItemViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 5/7/23.
//

import UIKit

class ClothingItemViewController: UIViewController {
    
    var clothingItemView = ClothingItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        navigationController?.isToolbarHidden = false
        
        var toolbarItemsArray = [UIBarButtonItem]()
        toolbarItemsArray.append(
            UIBarButtonItem(
                title: "Retake",
                style: .plain,
                target: self,
                action: #selector(retakeButtonTapped)
            )
        )
        toolbarItems = toolbarItemsArray
        
        view = clothingItemView
    }
    
    @objc private func backButtonTapped() {
        guard let closetViewController = presentingViewController as? ClosetViewController else {
            return
        }

        dismiss(animated: true)
        closetViewController.collectionView.reloadData()
    }
    @objc private func retakeButtonTapped() {
    }
}
