//
//  GeneratorViewController.swift
//  OutfitGenerator
//
//  Created by Jason on 6/29/23.
//

import FirebaseDatabase
import FirebaseStorage
import UIKit

class GeneratorViewController: UIViewController {
    
    // MARK: - Properties
    
    private var generatorView = GeneratorView()
    
    private var topsDatabaseReference: DatabaseReference!
    private var bottomsDatabaseReference: DatabaseReference!
    private var shoesDatabaseReference: DatabaseReference!
    
    private let storageReference = Storage.storage().reference()
    
    private let outfitGenerator = OutfitGenerator()

    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generatorView.delegate = self
        view = generatorView
        
        topsDatabaseReference = Database.database().reference().child("tops")
        bottomsDatabaseReference = Database.database().reference().child("bottoms")
        shoesDatabaseReference = Database.database().reference().child("shoes")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        outfitGenerator.getClothingItems {
            self.loadOutfit()
            self.setUpFavoriteButton()
        }
        
        generatorView.favoriteButton.isSelected = false
    }
    
    // MARK: - Outfit loading methods
    
    // Shows the initial outfit.
    private func loadOutfit() {
        outfitGenerator.currentOutfit.updateValue(nil, forKey: "top")
        outfitGenerator.currentOutfit.updateValue(nil, forKey: "bottom")
        outfitGenerator.currentOutfit.updateValue(nil, forKey: "shoes")
        
        if outfitGenerator.topsImageReferencesArray.isEmpty &&
            outfitGenerator.bottomsImageReferencesArray.isEmpty &&
            outfitGenerator.shoesImageReferencesArray.isEmpty
        {
            generatorView.startAddingItemsLabel.isHidden = false
        } else {
            let placeholderImage = UIImage(
                systemName: "photo"
            )?.withTintColor(
                .systemGray6,
                renderingMode: .alwaysOriginal
            )
            
            if outfitGenerator.topsImageReferencesArray.isEmpty {
                generatorView.noTopsLabel.isHidden = false
            } else {
                generatorView.topsImageView.sd_setImage(
                    with: storageReference.child(outfitGenerator.topsImageReferencesArray[0]),
                    placeholderImage: placeholderImage
                )
                
                outfitGenerator.currentOutfit["top"] = outfitGenerator.topsImageReferencesArray[0]
            }
            
            if outfitGenerator.bottomsImageReferencesArray.isEmpty {
                generatorView.noBottomsLabel.isHidden = false
            } else {
                generatorView.bottomsImageView.sd_setImage(
                    with: storageReference.child(outfitGenerator.bottomsImageReferencesArray[0]),
                    placeholderImage: placeholderImage
                )
                
                outfitGenerator.currentOutfit["bottom"] = outfitGenerator.bottomsImageReferencesArray[0]
            }
            
            if outfitGenerator.shoesImageReferencesArray.isEmpty {
                generatorView.noShoesLabel.isHidden = false
            } else {
                generatorView.shoesImageView.sd_setImage(
                    with: storageReference.child(outfitGenerator.shoesImageReferencesArray[0]),
                    placeholderImage: placeholderImage
                )
                
                outfitGenerator.currentOutfit["shoes"] = outfitGenerator.shoesImageReferencesArray[0]
            }
        }
    }
    
    private func setUpFavoriteButton() {
        if !outfitGenerator.topsImageReferencesArray.isEmpty &&
            !outfitGenerator.bottomsImageReferencesArray.isEmpty &&
            !outfitGenerator.shoesImageReferencesArray.isEmpty
        {
            generatorView.favoriteButton.isEnabled = true
        } else {
            generatorView.favoriteButton.isEnabled = false
        }
    }
}

// MARK: - Generator view protocol methods

extension GeneratorViewController: GeneratorViewDelegate {
    func addToFavorites(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        Database.database().reference().child("favorites").childByAutoId().setValue(outfitGenerator.currentOutfit)
    }
    
    // Changes the entire outfit.
    func generateOutfit() {
        if outfitGenerator.topsImageReferencesArray.isEmpty &&
            outfitGenerator.bottomsImageReferencesArray.isEmpty &&
            outfitGenerator.shoesImageReferencesArray.isEmpty
        {
            return
        }
        
        let currentOutfit = outfitGenerator.currentOutfit 
        let outfit = outfitGenerator.generate()

        if let top = outfit["top"] as? String {
            generatorView.topsImageView.sd_setImage(with: storageReference.child(top))
        }

        if let bottom = outfit["bottom"] as? String {
            generatorView.bottomsImageView.sd_setImage(with: storageReference.child(bottom))
        }

        if let shoes = outfit["shoes"] as? String {
            generatorView.shoesImageView.sd_setImage(with: storageReference.child(shoes))
        }
        
        if currentOutfit != outfit && generatorView.favoriteButton.isSelected {
            generatorView.favoriteButton.isSelected = false
        }
    }
    
    // Changes the item for a specific section.
    func changeItem(sender: UITapGestureRecognizer) {
        if outfitGenerator.topsImageReferencesArray.isEmpty &&
            outfitGenerator.bottomsImageReferencesArray.isEmpty &&
            outfitGenerator.shoesImageReferencesArray.isEmpty
        {
            return
        }
        
        let currentOutfit = outfitGenerator.currentOutfit
        
        guard let imageView = sender.view as? UIImageView else {
            print("Could not get image view for tap gesture recognizer.")
            return
        }
        
        if let item = outfitGenerator.change(forSection: imageView.tag) {
            let touchPoint = sender.location(in: imageView)
            let alphaValue = imageView.alpha(from: touchPoint)
            
            if alphaValue > 0 {
                imageView.sd_setImage(with: storageReference.child(item))
            }
        }
        
        let outfitAfterChange = outfitGenerator.currentOutfit
        
        if currentOutfit != outfitAfterChange && generatorView.favoriteButton.isSelected {
            generatorView.favoriteButton.isSelected = false
        }
    }
}
