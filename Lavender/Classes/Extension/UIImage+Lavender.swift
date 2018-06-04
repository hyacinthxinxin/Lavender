//
//  UIImage+Lavender.swift
//  Lavender
//
//  Created by 范新 on 2018/6/2.
//

import Foundation

extension Lavender where Base: UIImage {
    
}

extension UIImage {

    /// Creates an Image that is a color.
    ///
    /// - Parameters:
    ///   - color: The UIColor to create the image from.
    ///   - size: The size of the image to create.
    /// - Returns: A UIImage that is the color passed in.
    public static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: -size.height)
        UIGraphicsGetCurrentContext()?.setBlendMode(.multiply)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        color.setFill()
        UIGraphicsGetCurrentContext()?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.withRenderingMode(.alwaysOriginal)
    }

}
