//
//  OutfitGenerator.swift
//  OutfitGenerator
//
//  Created by Jason on 7/16/23.
//

import FirebaseDatabase
import Foundation

class OutfitGenerator {
    
    private var topsImageReferencesArray = [String]()
    private var bottomsImageReferencesArray = [String]()
    private var shoesImageReferencesArray = [String]()
    
    func getClothingItems() {
        var topsDatabaseReference: DatabaseReference!
        var bottomsDatabaseReference: DatabaseReference!
        var shoesDatabaseReference: DatabaseReference!
        
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
        }
        
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
        }
        
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
        }
    }
    
    func generate() -> [String: String?] {
        let top = topsImageReferencesArray.randomElement()
        let bottom = bottomsImageReferencesArray.randomElement()
        let shoes = shoesImageReferencesArray.randomElement()
        
        return ["top": top, "bottom": bottom, "shoes": shoes]
    }
}
