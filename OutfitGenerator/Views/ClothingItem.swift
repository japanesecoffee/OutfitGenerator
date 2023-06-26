//
//  ClothingItem.swift
//  OutfitGenerator
//
//  Created by Jason on 5/7/23.
//

import UIKit

class ClothingItem: UIView {
    
    var imageView = UIImageView()
    
    var toolbarItemsArray = [UIBarButtonItem]()
    
    var delegate: ClothingItemDelegate?
    
    let backButton: UIButton = {
        let backButtonConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let backButtonImage = UIImage(
            systemName: "chevron.left",
            withConfiguration: backButtonConfiguration
        )?.withTintColor(
            .systemGreen,
            renderingMode: .alwaysOriginal
        )
        let backButton = UIButton(type: .system)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.setTitle(" Back", for: .normal)
        backButton.setTitleColor(.systemGreen, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.sizeToFit()
        return backButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 20.0
        
        toolbarItemsArray.append(fixedSpace)
        toolbarItemsArray.append(
            UIBarButtonItem(
                title: "Retake",
                style: .plain,
                target: self,
                action: #selector(retakeButtonTapped)
            )
        )
        toolbarItemsArray.append(
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil, action: nil
            )
        )
        toolbarItemsArray.append(
            UIBarButtonItem(
                title: "Delete",
                style: .plain,
                target: self,
                action: #selector(deleteButtonTapped)
            )
        )
        toolbarItemsArray.append(fixedSpace)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubviews()
    }
    
    func createSubviews() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    @objc private func backButtonTapped() {
        delegate?.dismiss()
    }

    @objc private func retakeButtonTapped() {
        delegate?.launchCamera()
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.deleteItem()
    }
}

protocol ClothingItemDelegate {
    func deleteItem()
    
    func dismiss()
    
    func launchCamera()
}
