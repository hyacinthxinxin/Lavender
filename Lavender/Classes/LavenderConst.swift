//
//  LavenderConst.swift
//  Lavender
//
//  Created by 范新 on 2018/6/4.
//

import Foundation

/// LavenderConst 简写

public typealias LVC = LavenderConst

public struct LavenderConst {

    /// 屏幕宽度
    public static let screenWidth = UIScreen.main.bounds.width

    /// 屏幕高度
    public static let screenHeight = UIScreen.main.bounds.height

    /// 状态栏高度
    public static let statusBarHeight = UIApplication.shared.statusBarFrame.height

    /// 导航栏高度
    public static let navigationBarHeight: CGFloat = 44

    /// 选项栏高度
    public static let tabBarHeight: CGFloat = 49

    /// 是否为iPhoneX
    public static let isiphoneX: Bool = (screenHeight == CGFloat(812) && screenWidth == CGFloat(375))
}
