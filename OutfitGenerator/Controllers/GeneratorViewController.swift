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
        }
    }
    
    // MARK: - Outfit loading methods
    
    private func loadOutfit() {
        outfitGenerator.currentOutfit["top"] = nil
        outfitGenerator.currentOutfit["bottom"] = nil
        outfitGenerator.currentOutfit["shoes"] = nil
        
        if outfitGenerator.topsImageReferencesArray.isEmpty &&
            outfitGenerator.bottomsImageReferencesArray.isEmpty &&
            outfitGenerator.shoesImageReferencesArray.isEmpty
        {
            let label = UILabel(
                frame: CGRect(
                    x: 0,
                    y: (generatorView.bottomsImageView.frame.height - 50) / 2,
                    width: 200,
                    height: 50
                )
            )
            label.text = "Go to the closet tab to start adding items."
            label.numberOfLines = 0
            generatorView.bottomsImageView.addSubview(label)
        } else {
            let placeholderImage = UIImage(
                systemName: "photo"
            )?.withTintColor(
                .systemGray6,
                renderingMode: .alwaysOriginal
            )
            
            if outfitGenerator.topsImageReferencesArray.isEmpty {
                let label = UILabel(
                    frame: CGRect(
                        x: 0,
                        y: (generatorView.topsImageView.frame.height - 50) / 2,
                        width: 200,
                        height: 50
                    )
                )
                label.text = "No tops in closet."
                generatorView.topsImageView.addSubview(label)
            } else {
                generatorView.topsImageView.sd_setImage(
                    with: storageReference.child(outfitGenerator.topsImageReferencesArray[0]),
                    placeholderImage: placeholderImage
                )
                
                outfitGenerator.currentOutfit["top"] = outfitGenerator.topsImageReferencesArray[0]
            }
            
            if outfitGenerator.bottomsImageReferencesArray.isEmpty {
                let label = UILabel(
                    frame: CGRect(
                        x: 0,
                        y: (generatorView.bottomsImageView.frame.height - 50) / 2,
                        width: 200,
                        height: 50
                    )
                )
                label.text = "No bottoms in closet."
                generatorView.bottomsImageView.addSubview(label)
            } else {
                generatorView.bottomsImageView.sd_setImage(
                    with: storageReference.child(outfitGenerator.bottomsImageReferencesArray[0]),
                    placeholderImage: placeholderImage
                )
                
                outfitGenerator.currentOutfit["bottom"] = outfitGenerator.bottomsImageReferencesArray[0]
            }
            
            if outfitGenerator.shoesImageReferencesArray.isEmpty {
                let label = UILabel(
                    frame: CGRect(
                        x: 0,
                        y: (generatorView.shoesImageView.frame.height - 50) / 2,
                        width: 200,
                        height: 50
                    )
                )
                label.text = "No shoes in closet."
                generatorView.shoesImageView.addSubview(label)
            } else {
                generatorView.shoesImageView.sd_setImage(
                    with: storageReference.child(outfitGenerator.shoesImageReferencesArray[0]),
                    placeholderImage: placeholderImage
                )
                
                outfitGenerator.currentOutfit["shoes"] = outfitGenerator.shoesImageReferencesArray[0]
            }
        }
    }
}

// MARK: - Generator view protocol methods

extension GeneratorViewController: GeneratorViewDelegate {
    func generateOutfit() {
        if outfitGenerator.topsImageReferencesArray.isEmpty &&
            outfitGenerator.bottomsImageReferencesArray.isEmpty &&
            outfitGenerator.shoesImageReferencesArray.isEmpty
        {
            return
        }
        
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
    }
    
    func changeItem(sender: UITapGestureRecognizer) {
        if outfitGenerator.topsImageReferencesArray.isEmpty &&
            outfitGenerator.bottomsImageReferencesArray.isEmpty &&
            outfitGenerator.shoesImageReferencesArray.isEmpty
        {
            return
        }
        
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
    }
}
