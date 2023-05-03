//
//  ImageScaleTests.swift
//  OutfitGeneratorTests
//
//  Created by Jason on 5/2/23.
//

import XCTest
@testable import OutfitGenerator

final class ImageScaleTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testImageScaleReducesImageSize() throws {
        // Given.
        let imageSize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(imageSize)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // When.
        let scaledImage = image.resize(by: 0.5)
        
        // Then.
        XCTAssertLessThan(scaledImage.size.height * scaledImage.size.width, image.size.height * image.size.width)
    }

}
