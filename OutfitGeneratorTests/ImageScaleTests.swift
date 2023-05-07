//
//  ImageScaleTests.swift
//  OutfitGeneratorTests
//
//  Created by Jason on 5/2/23.
//

import XCTest
@testable import OutfitGenerator

final class ImageScaleTests: XCTestCase {

    var sut: UIImage!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = UIImage()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testImageScaleCanReduceImageSize() throws {
        // Given.
        let imageSize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(imageSize)
        sut = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // When.
        let scaledImage = sut.resize(by: 0.5)
        
        // Then.
        XCTAssertLessThan(scaledImage.size.height * scaledImage.size.width, sut.size.height * sut.size.width)
    }
    
    func testImageScaleCanIncreaseImageSize() throws {
        // Given.
        let imageSize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(imageSize)
        sut = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // When.
        let scaledImage = sut.resize(by: 1.5)
        
        // Then.
        XCTAssertGreaterThan(scaledImage.size.height * scaledImage.size.width, sut.size.height * sut.size.width)
    }
    
    func testScaledImageHasSameAspectRatio() throws {
        // Given.
        let imageSize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(imageSize)
        sut = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // When.
        let scaledImage = sut.resize(by: 0.5)
        
        // Then.
        XCTAssertEqual(scaledImage.size.width / scaledImage.size.height, sut.size.width / sut.size.height)
    }
}
