//
//  UIColor+Lavender.swift
//  Lavender
//
//  Created by 范新 on 2018/6/7.
//

import Foundation

// MARK: - Initializers
public extension UIColor {


    /// 通过Hex获得颜色
    ///
    /// - Parameters:
    ///   - hex: hex值
    ///   - alpha: 透明度
    convenience init(hex: Int, alpha: CGFloat) {
        let r = CGFloat((hex & 0xFF0000) >> 16)/255
        let g = CGFloat((hex & 0xFF00) >> 8)/255
        let b = CGFloat(hex & 0xFF)/255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }


    /// 通过Hex获得透明度为1的颜色
    ///
    /// - Parameter hex: hex值
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }


    /// 通过Hex字符串获得颜色
    ///
    /// - Parameter hexString: hex字符串
    convenience init(hexString: String) {
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }


    /// 通过整数红绿蓝获得颜色
    ///
    /// - Parameters:
    ///   - red: 红色色值
    ///   - green: 绿色色值
    ///   - blue: 蓝色色值
    ///   - transparency: 透明度
    convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        var trans: CGFloat {
            if transparency > 1 {
                return 1
            } else if transparency < 0 {
                return 0
            } else {
                return transparency
            }
        }
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }

}
