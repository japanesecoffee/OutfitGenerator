//
//  FavoritesViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 9/4/23.
//

import FirebaseDatabase
import FirebaseStorage
import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    private var favoritesImageReferencesArray = [[String: String?]]()
    
    private var favoritesDatabaseReferencesArray = [String]()
    
    private var favoritesDatabaseHandle: UInt!
    
    private var favoritesDatabaseReference: DatabaseReference!
    
    private let storageReference = Storage.storage().reference()
    
    private let favoritesView = FavoritesView()
    
    // MARK: - View controller lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        favoritesView.delegate = self
        view = favoritesView
        
        favoritesDatabaseReference = Database.database().reference().child("favorites")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addDatabaseListeners()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        favoritesDatabaseReference.removeObserver(withHandle: favoritesDatabaseHandle)
    }
    
    // MARK: - Data source methods

    // Adds a listener to the favorites node.
    private func addDatabaseListeners() {
        favoritesDatabaseHandle = favoritesDatabaseReference.observe(.value) { (snapshot) in
            self.favoritesImageReferencesArray = []
            self.favoritesDatabaseReferencesArray = []
            
            if snapshot.exists() {
                for favorite in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let outfit = favorite.value as? [String: String?] else {
                        return
                    }
                    self.favoritesImageReferencesArray.append(outfit)
                    self.favoritesDatabaseReferencesArray.append(favorite.key)
                }
            }
            
            self.loadFavorites()
        }
    }
    
    // MARK: - View setup methods
    
    // Shows favorite outfits.
    private func loadFavorites() {
        let padding = 20.0

        self.favoritesView.scrollView.frame = CGRect(
            x: self.view.frame.origin.x + padding,
            y: self.view.frame.origin.y,
            width: self.view.frame.size.width - padding * 3,
            height: self.view.frame.size.height
        )

        let scrollViewWidth = self.favoritesView.scrollView.frame.size.width
        let tabBarController = self.view.window?.rootViewController as! UITabBarController
        let tabBarHeight = tabBarController.tabBar.frame.size.height

        for index in 0..<self.favoritesImageReferencesArray.count {
            let view = UIView(frame: CGRect(
                x: CGFloat(index) * scrollViewWidth + padding,
                y: self.favoritesView.scrollView.bounds.origin.y + padding * 2,
                width: scrollViewWidth - padding,
                height: self.favoritesView.scrollView.bounds.size.height - tabBarHeight - padding * 4
            ))
            self.favoritesView.scrollView.addSubview(view)

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

            let outfit = self.favoritesImageReferencesArray[index]
            
            let topsImageView = UIImageView()
            topsImageView.contentMode = .scaleAspectFit
            if let top = outfit["top"] as? String {
                topsImageView.sd_setImage(with: self.storageReference.child(top))
            }
            let bottomsImageView = UIImageView()
            bottomsImageView.contentMode = .scaleAspectFit
            if let bottom = outfit["bottom"] as? String {
                bottomsImageView.sd_setImage(with: self.storageReference.child(bottom))
            }
            let shoesImageView = UIImageView()
            shoesImageView.contentMode = .scaleAspectFit
            if let shoes = outfit["shoes"] as? String {
                shoesImageView.sd_setImage(with: self.storageReference.child(shoes))
            }

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

        self.favoritesView.scrollView.contentSize = CGSize(
            width: scrollViewWidth * CGFloat(self.favoritesImageReferencesArray.count),
            height: self.favoritesView.scrollView.frame.size.height
        )
    }
}

// MARK: - Favorites view protocol methods

extension FavoritesViewController: FavoritesViewDelegate {
    func deleteFavorite() {
        let index = Int(favoritesView.scrollView.contentOffset.x / favoritesView.scrollView.bounds.size.width)
        let databaseReference = favoritesDatabaseReference.child(favoritesDatabaseReferencesArray[index])
        
        // Deletes reference from Firebase Realtime Database.
        databaseReference.removeValue { (error, databaseReference) in
            if let error = error {
                print("There was an error deleting from Realtime Database: \(error)")
            }
        }
        
        // Removes existing subviews so that new subviews can be added without overlap.
        for subview in favoritesView.scrollView.subviews {
            subview.removeFromSuperview()
        }
    }
}
