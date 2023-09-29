//
//  FavoritesView.swift
//  OutfitGenerator
//
//  Created by Jason on 9/8/23.
//

import UIKit

class FavoritesView: UIView {
    
    var delegate: FavoritesViewDelegate?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isOpaque = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
        
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tabBarController = window?.rootViewController as! UITabBarController
        
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: tabBarController.tabBar.topAnchor, constant: -5).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.deleteFavorite()
    }
}

protocol FavoritesViewDelegate {
    func deleteFavorite()
}
