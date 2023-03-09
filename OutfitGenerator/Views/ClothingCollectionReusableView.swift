//
//  ClothingCollectionReusableView.swift
//  OutfitGenerator
//
//  Created by Jason on 2/21/23.
//

import UIKit

class ClothingCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ClothingCollectionReusableView"
    
    var delegate: HeaderDelegate?
    
    let title: UILabel = {
        let title = UILabel()
        return title
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(
            systemName: "chevron.up"
        )?.withTintColor(
            .systemGreen,
            renderingMode: .alwaysOriginal
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let collectionViewCellWidth = (self.frame.size.width / 3) - 3
        
        let stackView = UIStackView()
        stackView.clipsToBounds = true
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: 20,
            bottom: 0,
            trailing: 20
        )
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView.addArrangedSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: collectionViewCellWidth / 6).isActive = true
        
        stackView.addArrangedSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: collectionViewCellWidth / 6).isActive = true
        button.widthAnchor.constraint(equalToConstant: collectionViewCellWidth / 6).isActive = true
        button.layer.cornerRadius = collectionViewCellWidth / 12
        button.addTarget(self, action: #selector(headerButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func headerButtonTapped(sender: UIButton!) {
        delegate?.toggleNumberOfItems(inSection: sender.tag)
    }
}

protocol HeaderDelegate {
    func toggleNumberOfItems(inSection: Int)
}
