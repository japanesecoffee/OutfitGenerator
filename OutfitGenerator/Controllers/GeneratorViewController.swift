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
    
    private var generatorView = GeneratorView()
    
    private var topsDatabaseReference: DatabaseReference!
    private var bottomsDatabaseReference: DatabaseReference!
    private var shoesDatabaseReference: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        view = generatorView
        
        topsDatabaseReference = Database.database().reference().child("tops")
        bottomsDatabaseReference = Database.database().reference().child("bottoms")
        shoesDatabaseReference = Database.database().reference().child("shoes")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadOutfit()
    }
    
    private func loadOutfit() {
        let storageReference = Storage.storage().reference()
        
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
                    with: storageReference.child(value),
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
                    with: storageReference.child(value),
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
                    with: storageReference.child(value),
                    placeholderImage: placeholderImage
                )
            }
        }
    }
}
