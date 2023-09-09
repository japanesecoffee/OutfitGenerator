//
//  FavoritesView.swift
//  OutfitGenerator
//
//  Created by Jason on 9/8/23.
//

import UIKit

class FavoritesView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isOpaque = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        let padding = 20.0
        
        scrollView.frame = CGRect(
            x: frame.origin.x + padding,
            y: frame.origin.y,
            width: frame.size.width - padding * 3,
            height: frame.size.height
        )
        
        let itemCount = 4
        let scrollViewWidth = scrollView.frame.size.width
        
        let statusBarHeight = self.window?.windowScene?.statusBarManager?.statusBarFrame.height
        let tabBarController = self.window?.rootViewController as! UITabBarController
        let tabBarHeight = tabBarController.tabBar.frame.size.height
        
        for i in 0..<itemCount {
            let view = UIView(frame: CGRect(
                x: CGFloat(i) * scrollViewWidth + padding,
                y: scrollView.bounds.origin.y + statusBarHeight!,
                width: scrollViewWidth - padding,
                height: scrollView.bounds.size.height - statusBarHeight! - tabBarHeight - padding
            ))
            view.backgroundColor = .systemGreen
            scrollView.addSubview(view)
            
            let stackView = UIStackView()
            stackView.clipsToBounds = true
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.alignment = .center
            stackView.isLayoutMarginsRelativeArrangement = true
            view.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                stackView.topAnchor.constraint(equalTo: view.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            let topsImageView = UIImageView()
            topsImageView.backgroundColor = .white
            let bottomsImageView = UIImageView()
            bottomsImageView.backgroundColor = .white
            let shoesImageView = UIImageView()
            shoesImageView.backgroundColor = .white
            
            stackView.addArrangedSubview(topsImageView)
            topsImageView.translatesAutoresizingMaskIntoConstraints = false
            topsImageView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 3).isActive = true
            topsImageView.widthAnchor.constraint(equalToConstant: view.frame.size.height / 3).isActive = true
            
            stackView.addArrangedSubview(bottomsImageView)
            bottomsImageView.translatesAutoresizingMaskIntoConstraints = false
            bottomsImageView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 3).isActive = true
            bottomsImageView.widthAnchor.constraint(equalToConstant: view.frame.size.height / 3).isActive = true
            
            stackView.addArrangedSubview(shoesImageView)
            shoesImageView.translatesAutoresizingMaskIntoConstraints = false
            shoesImageView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 3).isActive = true
            shoesImageView.widthAnchor.constraint(equalToConstant: view.frame.size.height / 3).isActive = true
        }
        
        scrollView.contentSize = CGSize(
            width: scrollViewWidth * CGFloat(itemCount),
            height: scrollView.frame.size.height
        )
    }
}
