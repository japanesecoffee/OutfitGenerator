//
//  FavoritesView.swift
//  OutfitGenerator
//
//  Created by Jason on 9/8/23.
//

import UIKit

class FavoritesView: UIView {
    
    let scrollView: UIScrollView = {
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
}
