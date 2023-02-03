//
//  OutfitGeneratorTests.swift
//  OutfitGeneratorTests
//
//  Created by Jason on 10/16/22.
//

import XCTest
@testable import OutfitGenerator

final class BackgroundRemovalTests: XCTestCase {
    
    var sut: BackgroundRemoval!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = BackgroundRemoval()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testBackgroundRemovalAPIReturnsImageData() throws {
        // Given.
        let imageSize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(imageSize)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        var imageData: NSData?
        
        let promise = expectation(description: "Completion handler invoked.")
        
        // When.
        sut.removeBackground(for: image) { (segmentedImageData) in
            imageData = segmentedImageData
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        // Then.
        XCTAssertNotNil(imageData)
    }
}
