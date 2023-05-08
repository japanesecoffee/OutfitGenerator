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

        view = clothingItemView
    }
}
