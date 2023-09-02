//
//  OutfitGeneratorTests.swift
//  OutfitGeneratorTests
//
//  Created by Jason on 8/31/23.
//

import XCTest
@testable import OutfitGenerator

final class OutfitGeneratorTests: XCTestCase {
    
    var sut: OutfitGenerator!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = OutfitGenerator()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Outfit test methods

    func testNextOutfitHasNilValuesWhenSectionsHaveZeroItems() throws {
        // Given.
        sut.topsImageReferencesArray = []
        sut.bottomsImageReferencesArray = []
        sut.shoesImageReferencesArray = []
        
        sut.currentOutfit = ["top": nil, "bottom": nil, "shoes": nil]
        let currentOutfit = sut.currentOutfit
        
        // When.
        let nextOutfit = sut.generate()
        
        // Then.
        XCTAssertEqual(currentOutfit, nextOutfit)
    }
    
    func testNextOutfitIsTheSameWhenSectionsHaveOneItem() throws {
        // Given.
        sut.topsImageReferencesArray = ["images/\(UUID().uuidString).jpeg"]
        sut.bottomsImageReferencesArray = ["images/\(UUID().uuidString).jpeg"]
        sut.shoesImageReferencesArray = ["images/\(UUID().uuidString).jpeg"]
        
        sut.currentOutfit["top"] = sut.topsImageReferencesArray[0]
        sut.currentOutfit["bottom"] = sut.bottomsImageReferencesArray[0]
        sut.currentOutfit["shoes"] = sut.shoesImageReferencesArray[0]
        let currentOutfit = sut.currentOutfit
        
        // When.
        let nextOutfit = sut.generate()
        
        // Then.
        XCTAssertEqual(currentOutfit, nextOutfit)
    }
    
    func testNextOutfitIsDifferentWhenASectionHasAtLeastTwoItems() throws {
        // Given.
        sut.topsImageReferencesArray = [
            "images/\(UUID().uuidString).jpeg",
            "images/\(UUID().uuidString).jpeg"
        ]
        sut.bottomsImageReferencesArray = ["images/\(UUID().uuidString).jpeg"]
        sut.shoesImageReferencesArray = ["images/\(UUID().uuidString).jpeg"]
        
        sut.currentOutfit["top"] = sut.topsImageReferencesArray[0]
        sut.currentOutfit["bottom"] = sut.bottomsImageReferencesArray[0]
        sut.currentOutfit["shoes"] = sut.shoesImageReferencesArray[0]
        let currentOutfit = sut.currentOutfit
        
        // When.
        let nextOutfit = sut.generate()
        
        // Then.
        XCTAssertNotEqual(currentOutfit, nextOutfit)
    }
    
    // MARK: - Item test methods
    
    func testNextItemIsNilWhenTheSectionHasZeroItems() throws {
        // Given.
        sut.topsImageReferencesArray = []
        sut.bottomsImageReferencesArray = []
        sut.shoesImageReferencesArray = []
        
        let randomSection = Int.random(in: 0...2)
        
        // When.
        let nextItem = sut.change(forSection: randomSection)
        
        // Then.
        XCTAssertNil(nextItem)
    }
    
    func testNextItemIsTheSameWhenTheSectionHasOneItem() throws {
        // Given.
        sut.topsImageReferencesArray = ["images/\(UUID().uuidString).jpeg"]
        sut.bottomsImageReferencesArray = ["images/\(UUID().uuidString).jpeg"]
        sut.shoesImageReferencesArray = ["images/\(UUID().uuidString).jpeg"]
        
        sut.currentOutfit["top"] = sut.topsImageReferencesArray[0]
        sut.currentOutfit["bottom"] = sut.bottomsImageReferencesArray[0]
        sut.currentOutfit["shoes"] = sut.shoesImageReferencesArray[0]
        
        let randomSection = Int.random(in: 0...2)
        let section = ["top", "bottom", "shoes"]
        
        let currentItem = sut.currentOutfit[section[randomSection]]
        
        // When.
        let nextItem = sut.change(forSection: randomSection)
        
        // Then.
        XCTAssertEqual(currentItem, nextItem)
    }
    
    func testNextItemIsDifferentWhenTheSectionHasAtLeastTwoItems() throws {
        // Given.
        sut.topsImageReferencesArray = [
            "images/\(UUID().uuidString).jpeg",
            "images/\(UUID().uuidString).jpeg"
        ]
        sut.bottomsImageReferencesArray = [
            "images/\(UUID().uuidString).jpeg",
            "images/\(UUID().uuidString).jpeg"
        ]
        sut.shoesImageReferencesArray = [
            "images/\(UUID().uuidString).jpeg",
            "images/\(UUID().uuidString).jpeg"
        ]
        
        sut.currentOutfit["top"] = sut.topsImageReferencesArray[0]
        sut.currentOutfit["bottom"] = sut.bottomsImageReferencesArray[0]
        sut.currentOutfit["shoes"] = sut.shoesImageReferencesArray[0]
        
        let randomSection = Int.random(in: 0...2)
        let section = ["top", "bottom", "shoes"]
        
        let currentItem = sut.currentOutfit[section[randomSection]]
        
        // When.
        let nextItem = sut.change(forSection: randomSection)
        
        // Then.
        XCTAssertNotEqual(currentItem, nextItem)
    }
}
