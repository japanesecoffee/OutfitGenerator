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
    
    var delegate: GeneratorViewDelegate?
    
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
        topsImageView.tag = 0
        verticalStackView.addArrangedSubview(topsImageView)
        topsImageView.translatesAutoresizingMaskIntoConstraints = false
        topsImageView.isUserInteractionEnabled = true
        topsImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageViewTapped)
        ))
        
        bottomsImageView.contentMode = .scaleAspectFit
        bottomsImageView.tag = 1
        verticalStackView.addArrangedSubview(bottomsImageView)
        bottomsImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomsImageView.isUserInteractionEnabled = true
        bottomsImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageViewTapped)
        ))
        
        shoesImageView.contentMode = .scaleAspectFit
        shoesImageView.tag = 2
        verticalStackView.addArrangedSubview(shoesImageView)
        shoesImageView.translatesAutoresizingMaskIntoConstraints = false
        shoesImageView.isUserInteractionEnabled = true
        shoesImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageViewTapped)
        ))
        
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
        leftSideButton.addTarget(self, action: #selector(sideButtonTapped), for: .touchUpInside)

        horizontalStackView.addArrangedSubview(verticalStackView)

        horizontalStackView.addArrangedSubview(rightSideButton)
        rightSideButton.translatesAutoresizingMaskIntoConstraints = false
        rightSideButton.addTarget(self, action: #selector(sideButtonTapped), for: .touchUpInside)
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
    
    @objc func sideButtonTapped() {
        delegate?.generateOutfit()
    }
    
    @objc func imageViewTapped(sender: UITapGestureRecognizer) {
        delegate?.changeItem(sender: sender)
    }
}

protocol GeneratorViewDelegate {
    func changeItem(sender: UITapGestureRecognizer)
    
    func generateOutfit()
}
