//
//  Lavender+UICollectionReusableView.swift
//  Lavender
//
//  Created by 范新 on 2018/6/12.
//

public extension UICollectionReusableView {


    /// nib
    static var nib:UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

    /// 重用标志
    static var reuseIdentifier: String {
        return String(describing: self)
    }

}
