//
//  ClothingCollectionReusableView.swift
//  OutfitGenerator
//
//  Created by Jason on 2/21/23.
//

import UIKit

class ClothingCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ClothingCollectionReusableView"
    
    private let title: UILabel = {
        let title = UILabel()
        title.text = "Tops"
        return title
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let headerWidth = self.frame.size.width
        
        let stackView = UIStackView()
        stackView.clipsToBounds = true
        stackView.axis = .horizontal
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: headerWidth / 6)
        ])
        
        stackView.addArrangedSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.widthAnchor.constraint(equalToConstant: headerWidth * (2 / 3)).isActive = true
        
        stackView.addArrangedSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: headerWidth / 3).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
