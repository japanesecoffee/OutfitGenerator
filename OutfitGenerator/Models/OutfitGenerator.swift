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
    
    var currentOutfit: [String: String?] = ["top": nil, "bottom": nil, "shoes": nil]
    
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
        
        var outfit = ["top": top, "bottom": bottom, "shoes": shoes]
        
        var sections = [String: [String]]()
        
        if topsImageReferencesArray.count > 1 {
            sections["top"] = topsImageReferencesArray
        }
        
        if bottomsImageReferencesArray.count > 1 {
            sections["bottom"] = bottomsImageReferencesArray
        }
        
        if shoesImageReferencesArray.count > 1 {
            sections["shoes"] = shoesImageReferencesArray
        }
        
        if let section = sections.randomElement() {
            if outfit == currentOutfit {
                let currentItem = outfit[section.key]!!
                outfit[section.key] = nextItem(to: currentItem, in: section.value)
            }
        }
        
        currentOutfit = outfit
        
        return outfit
    }
    
    func change(forSection: Int) -> String? {
        let sectionArray: [String]
        let section: String
        
        if forSection == 0 {
            sectionArray = topsImageReferencesArray
            section = "top"
        } else if forSection == 1 {
            sectionArray = bottomsImageReferencesArray
            section = "bottom"
        } else {
            sectionArray = shoesImageReferencesArray
            section = "shoes"
        }
        
        var item = sectionArray.randomElement()
        
        if sectionArray.count > 1 {
            if item == currentOutfit[section] {
                item = nextItem(to: item!, in: sectionArray)
            }
        }
        
        currentOutfit[section] = item
        
        return item
    }
    
    private func nextItem(to currentItem: String, in array: [String]) -> String {
        let currentIndex = array.firstIndex(of: currentItem)!
        let nextIndex = array.indices.contains(currentIndex + 1) ? currentIndex + 1 : 0
        return array[nextIndex]
    }
}
