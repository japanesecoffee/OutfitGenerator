//
//  ViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 10/14/22.
//

import UIKit

class ViewController: UIViewController {
    
    var stylesView = Styles()
    
    override func loadView() {
        view = stylesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

