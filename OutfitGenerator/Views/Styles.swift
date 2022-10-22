//
//  Styles.swift
//  OutfitGenerator
//
//  Created by Jason on 10/20/22.
//

import UIKit

class Styles: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    
    // Sets up views to create a style.
    func createSubviews() {
        backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGreen
        button.setTitle("Create", for: .normal)
        
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
