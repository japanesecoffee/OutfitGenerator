//
//  ImageViewAlpha.swift
//  OutfitGenerator
//
//  Created by Jason on 7/25/23.
//

import Foundation
import UIKit

extension UIImageView {
    func alpha(from point: CGPoint) -> CGFloat {
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let alphaInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: alphaInfo.rawValue
        )
        
        context?.translateBy(x: -point.x, y: -point.y)
        
        self.layer.render(in: context!)
        
        let floatAlpha = CGFloat(pixel[3])
        return floatAlpha
    }
}
