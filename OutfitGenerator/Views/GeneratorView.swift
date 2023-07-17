//
//  GeneratorView.swift
//  OutfitGenerator
//
//  Created by Jason on 7/12/23.
//

import UIKit

class GeneratorView: UIView {

    var topsImageView = UIImageView()
    var bottomsImageView = UIImageView()
    var shoesImageView = UIImageView()
    
    let leftSideButton = UIButton(type: .system)
    let rightSideButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        let verticalStackView = UIStackView()
        verticalStackView.clipsToBounds = true
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .center
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        topsImageView.contentMode = .scaleAspectFit
        verticalStackView.addArrangedSubview(topsImageView)
        topsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomsImageView.contentMode = .scaleAspectFit
        verticalStackView.addArrangedSubview(bottomsImageView)
        bottomsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        shoesImageView.contentMode = .scaleAspectFit
        verticalStackView.addArrangedSubview(shoesImageView)
        shoesImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalStackView = UIStackView()
        horizontalStackView.clipsToBounds = true
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.alignment = .center
        horizontalStackView.isLayoutMarginsRelativeArrangement = true
        addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        horizontalStackView.addArrangedSubview(leftSideButton)
        leftSideButton.translatesAutoresizingMaskIntoConstraints = false

        horizontalStackView.addArrangedSubview(verticalStackView)

        horizontalStackView.addArrangedSubview(rightSideButton)
        rightSideButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let statusBarHeight = self.window?.windowScene?.statusBarManager?.statusBarFrame.height
        let tabBarController = self.window?.rootViewController as! UITabBarController
        let tabBarHeight = tabBarController.tabBar.frame.size.height
        let height = self.frame.size.height - statusBarHeight! - tabBarHeight
        let width = self.frame.size.width - (height / 3)
        
        topsImageView.heightAnchor.constraint(equalToConstant: height / 3).isActive = true
        topsImageView.widthAnchor.constraint(equalToConstant: height / 3).isActive = true
        
        bottomsImageView.heightAnchor.constraint(equalToConstant: height / 3).isActive = true
        bottomsImageView.widthAnchor.constraint(equalToConstant: height / 3).isActive = true
        
        shoesImageView.heightAnchor.constraint(equalToConstant: height / 3).isActive = true
        shoesImageView.widthAnchor.constraint(equalToConstant: height / 3).isActive = true
        
        leftSideButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        leftSideButton.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        
        rightSideButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        rightSideButton.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
    }
}
