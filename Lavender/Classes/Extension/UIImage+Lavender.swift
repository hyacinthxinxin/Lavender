//
//  UIImage+Lavender.swift
//  Lavender
//
//  Created by 范新 on 2018/6/2.
//

import Foundation

extension Lavender where Base: UIImage {
    
}

public extension UIImage {

    /// 纯色图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 尺寸
    /// - Returns: 图片
    public static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: max(0.5, size.width), height: max(0.5, size.height)), false, 0)
        UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: -max(0.5, size.height))
        UIGraphicsGetCurrentContext()?.setBlendMode(.multiply)
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: max(0.5, size.width), height: max(0.5, size.height)))
        color.setFill()
        UIGraphicsGetCurrentContext()?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.withRenderingMode(.alwaysOriginal)
    }

}

extension UIImage {
    // 纯色图片 默认大小 {1, 1}
    static func fx_pureColorImage(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: max(0.5, size.width), height: max(0.5, size.height)), false, 0)
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.withRenderingMode(.alwaysOriginal)
    }

}
