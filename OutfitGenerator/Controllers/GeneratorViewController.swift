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
        
        outfitGenerator.getClothingItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadOutfit()
    }
    
    // MARK: - Outfit loading methods
    
    private func loadOutfit() {
        let placeholderImage = UIImage(
            systemName: "photo"
        )?.withTintColor(
            .systemGray6,
            renderingMode: .alwaysOriginal
        )
        
        topsDatabaseReference.observeSingleEvent(of: .childAdded) { (snapshot) in
            if snapshot.exists() {
                guard let value = snapshot.value as? String else {
                    return
                }
                self.generatorView.topsImageView.sd_setImage(
                    with: self.storageReference.child(value),
                    placeholderImage: placeholderImage
                )
            }
        }
        
        bottomsDatabaseReference.observeSingleEvent(of: .childAdded) { (snapshot) in
            if snapshot.exists() {
                guard let value = snapshot.value as? String else {
                    return
                }
                self.generatorView.bottomsImageView.sd_setImage(
                    with: self.storageReference.child(value),
                    placeholderImage: placeholderImage
                )
            }
        }
        
        shoesDatabaseReference.observeSingleEvent(of: .childAdded) { (snapshot) in
            if snapshot.exists() {
                guard let value = snapshot.value as? String else {
                    return
                }
                self.generatorView.shoesImageView.sd_setImage(
                    with: self.storageReference.child(value),
                    placeholderImage: placeholderImage
                )
            }
        }
    }
}

// MARK: - Generator view protocol methods

extension GeneratorViewController: GeneratorViewDelegate {
    func generateOutfit() {
        let outfit = outfitGenerator.generate()
        
        guard let top = outfit["top"] as? String else {
            print("Top not found.")
            return
        }
        
        guard let bottom = outfit["bottom"] as? String else {
            print("Bottom not found.")
            return
        }
        
        guard let shoes = outfit["shoes"] as? String else {
            print("Shoes not found.")
            return
        }
        
        generatorView.topsImageView.sd_setImage(with: storageReference.child(top))
        generatorView.bottomsImageView.sd_setImage(with: storageReference.child(bottom))
        generatorView.shoesImageView.sd_setImage(with: storageReference.child(shoes))
    }
    
    func changeItem(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else {
            print("Could not get image view for tap gesture recognizer.")
            return
        }
        
        let touchPoint = sender.location(in: imageView)
        let alphaValue = imageView.alpha(from: touchPoint)
        
        if alphaValue > 0 {            
            guard let item = outfitGenerator.change(forSection: imageView.tag) else {
                print("No items found.")
                return
            }
            
            imageView.sd_setImage(with: storageReference.child(item))
        }
    }
}
