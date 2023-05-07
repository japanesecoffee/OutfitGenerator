//
//  ImageScale.swift
//  OutfitGenerator
//
//  Created by Jason on 5/2/23.
//

import Foundation
import UIKit

extension UIImage {
    func resize(by scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        let image = UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return image.withRenderingMode(renderingMode)
    }
}
