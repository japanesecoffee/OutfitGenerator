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
        if favoritesImageReferencesArray.isEmpty {
            favoritesView.deleteButton.isHidden = true
        } else {
            favoritesView.deleteButton.isHidden = false
            
            let padding = 20.0
            
            favoritesView.scrollView.frame = CGRect(
                x: view.frame.origin.x + padding,
                y: view.frame.origin.y,
                width: view.frame.size.width - padding * 3,
                height: view.frame.size.height
            )
            
            let scrollViewWidth = favoritesView.scrollView.frame.size.width
            let tabBarController = view.window?.rootViewController as! UITabBarController
            let tabBarHeight = tabBarController.tabBar.frame.size.height
            
            for index in 0..<favoritesImageReferencesArray.count {                
                let stackView = UIStackView(frame: CGRect(
                    x: CGFloat(index) * scrollViewWidth + padding,
                    y: favoritesView.scrollView.bounds.origin.y + padding * 2,
                    width: scrollViewWidth - padding,
                    height: favoritesView.scrollView.bounds.size.height - tabBarHeight - padding * 4
                ))
                stackView.layer.borderWidth = 1
                stackView.layer.borderColor = UIColor.systemGray.cgColor
                stackView.layer.cornerRadius = 5
                stackView.layer.masksToBounds = true
                stackView.clipsToBounds = true
                stackView.axis = .vertical
                stackView.distribution = .equalSpacing
                stackView.alignment = .center
                stackView.isLayoutMarginsRelativeArrangement = true
                favoritesView.scrollView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = true
                
                let outfit = favoritesImageReferencesArray[index]
                
                let topsImageView = UIImageView()
                topsImageView.contentMode = .scaleAspectFit
                if let top = outfit["top"] as? String {
                    topsImageView.sd_setImage(with: storageReference.child(top))
                }
                let bottomsImageView = UIImageView()
                bottomsImageView.contentMode = .scaleAspectFit
                if let bottom = outfit["bottom"] as? String {
                    bottomsImageView.sd_setImage(with: storageReference.child(bottom))
                }
                let shoesImageView = UIImageView()
                shoesImageView.contentMode = .scaleAspectFit
                if let shoes = outfit["shoes"] as? String {
                    shoesImageView.sd_setImage(with: storageReference.child(shoes))
                }
                
                stackView.addArrangedSubview(topsImageView)
                topsImageView.translatesAutoresizingMaskIntoConstraints = false
                topsImageView.heightAnchor.constraint(equalToConstant: stackView.frame.size.height / 3).isActive = true
                topsImageView.widthAnchor.constraint(equalToConstant: stackView.frame.size.height / 3).isActive = true
                
                stackView.addArrangedSubview(bottomsImageView)
                bottomsImageView.translatesAutoresizingMaskIntoConstraints = false
                bottomsImageView.heightAnchor.constraint(equalToConstant: stackView.frame.size.height / 3).isActive = true
                bottomsImageView.widthAnchor.constraint(equalToConstant: stackView.frame.size.height / 3).isActive = true
                
                stackView.addArrangedSubview(shoesImageView)
                shoesImageView.translatesAutoresizingMaskIntoConstraints = false
                shoesImageView.heightAnchor.constraint(equalToConstant: stackView.frame.size.height / 3).isActive = true
                shoesImageView.widthAnchor.constraint(equalToConstant: stackView.frame.size.height / 3).isActive = true
            }
            
            favoritesView.scrollView.contentSize = CGSize(
                width: scrollViewWidth * CGFloat(favoritesImageReferencesArray.count),
                height: favoritesView.scrollView.frame.size.height
            )
        }
    }
}

// MARK: - Favorites view protocol methods

extension FavoritesViewController: FavoritesViewDelegate {
    func deleteFavorite() {
        let alert = UIAlertController(
            title: "Delete Favorite",
            message: "This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { (action) in
            let index = Int(self.favoritesView.scrollView.contentOffset.x / self.favoritesView.scrollView.bounds.size.width)
            let databaseReference = self.favoritesDatabaseReference.child(self.favoritesDatabaseReferencesArray[index])
            
            // Deletes reference from Firebase Realtime Database.
            databaseReference.removeValue { (error, databaseReference) in
                if let error = error {
                    print("There was an error deleting from Realtime Database: \(error)")
                }
            }
            
            // Removes existing subviews so that new subviews can be added without overlap.
            for subview in self.favoritesView.scrollView.subviews {
                subview.removeFromSuperview()
            }
        })
        
        present(alert, animated: true)
    }
}
