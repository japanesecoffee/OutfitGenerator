//
//  OutfitGenerator.swift
//  OutfitGenerator
//
//  Created by Jason on 7/16/23.
//

import FirebaseDatabase
import Foundation

class OutfitGenerator {
    
    typealias FinishedGettingItems = () -> Void
    
    var topsImageReferencesArray = [String]()
    var bottomsImageReferencesArray = [String]()
    var shoesImageReferencesArray = [String]()
    
    func getClothingItems(completion: @escaping FinishedGettingItems) {
        let topsDatabaseReference = Database.database().reference().child("tops")
        let bottomsDatabaseReference = Database.database().reference().child("bottoms")
        let shoesDatabaseReference = Database.database().reference().child("shoes")
        
        let group = DispatchGroup()
        
        group.enter()
        topsDatabaseReference.observeSingleEvent(of: .value) { (snapshot) in
            self.topsImageReferencesArray = []
            
            if snapshot.exists() {
                for childNode in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let value = childNode.value as? String else {
                        return
                    }
                    self.topsImageReferencesArray.append(value)
                }
            }
            group.leave()
        }
        
        group.enter()
        bottomsDatabaseReference.observeSingleEvent(of: .value) { (snapshot) in
            self.bottomsImageReferencesArray = []
            
            if snapshot.exists() {
                for childNode in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let value = childNode.value as? String else {
                        return
                    }
                    self.bottomsImageReferencesArray.append(value)
                }
            }
            group.leave()
        }
        
        group.enter()
        shoesDatabaseReference.observeSingleEvent(of: .value) { (snapshot) in
            self.shoesImageReferencesArray = []
            
            if snapshot.exists() {
                for childNode in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let value = childNode.value as? String else {
                        return
                    }
                    self.shoesImageReferencesArray.append(value)
                }
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
    
    func generate() -> [String: String?] {
        let top = topsImageReferencesArray.randomElement()
        let bottom = bottomsImageReferencesArray.randomElement()
        let shoes = shoesImageReferencesArray.randomElement()
        
        return ["top": top, "bottom": bottom, "shoes": shoes]
    }
    
    func change(forSection: Int) -> String? {
        let item: String?
        
        if forSection == 0 {
            item = topsImageReferencesArray.randomElement()
        } else if forSection == 1 {
            item = bottomsImageReferencesArray.randomElement()
        } else {
            item = shoesImageReferencesArray.randomElement()
        }
        
        return item
    }
}
