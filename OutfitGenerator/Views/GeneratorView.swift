//
//  GeneratorView.swift
//  OutfitGenerator
//
//  Created by Jason on 7/12/23.
//

import UIKit

class GeneratorView: UIView {
    
    // MARK: - Properties
    
    var delegate: GeneratorViewDelegate?
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.clipsToBounds = true
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.clipsToBounds = true
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let topsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tag = 0
        return imageView
    }()
    
    let bottomsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tag = 1
        return imageView
    }()
    
    let shoesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tag = 2
        return imageView
    }()
    
    let noTopsLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        label.text = "No tops in closet."
        label.isHidden = true
        return label
    }()
    
    let noBottomsLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        label.text = "No bottoms in closet."
        label.isHidden = true
        return label
    }()
    
    let noShoesLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        label.text = "No shoes in closet."
        label.isHidden = true
        return label
    }()
    
    let startAddingItemsLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        label.text = "Go to the closet tab to start adding items."
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    let leftSideButton = UIButton(type: .system)
    let rightSideButton = UIButton(type: .system)
    
    // MARK: - Initialization methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.addArrangedSubview(topsImageView)
        topsImageView.translatesAutoresizingMaskIntoConstraints = false
        topsImageView.isUserInteractionEnabled = true
        topsImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageViewTapped)
        ))
        
        topsImageView.addSubview(noTopsLabel)
        noTopsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.addArrangedSubview(bottomsImageView)
        bottomsImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomsImageView.isUserInteractionEnabled = true
        bottomsImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageViewTapped)
        ))
        
        bottomsImageView.addSubview(noBottomsLabel)
        noBottomsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.addArrangedSubview(shoesImageView)
        shoesImageView.translatesAutoresizingMaskIntoConstraints = false
        shoesImageView.isUserInteractionEnabled = true
        shoesImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageViewTapped)
        ))
        
        shoesImageView.addSubview(noShoesLabel)
        noShoesLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        addSubview(startAddingItemsLabel)
        startAddingItemsLabel.translatesAutoresizingMaskIntoConstraints = false
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
        
        noTopsLabel.center = CGPoint(
            x: topsImageView.frame.size.width / 2,
            y: topsImageView.frame.size.height / 2
        )
        noBottomsLabel.center = CGPoint(
            x: bottomsImageView.frame.size.width / 2,
            y: bottomsImageView.frame.size.height / 2
        )
        noShoesLabel.center = CGPoint(
            x: shoesImageView.frame.size.width / 2,
            y: shoesImageView.frame.size.height / 2
        )
        startAddingItemsLabel.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        leftSideButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        leftSideButton.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        
        rightSideButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        rightSideButton.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
    }
    
    // MARK: - Action methods
    
    @objc private func sideButtonTapped() {
        delegate?.generateOutfit()
    }
    
    @objc private func imageViewTapped(sender: UITapGestureRecognizer) {
        delegate?.changeItem(sender: sender)
    }
}

protocol GeneratorViewDelegate {
    func changeItem(sender: UITapGestureRecognizer)
    
    func generateOutfit()
}
