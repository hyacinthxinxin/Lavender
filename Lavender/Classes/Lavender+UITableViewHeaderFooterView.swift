//
//  Lavender+UITableViewHeaderFooterView.swift
//  Lavender
//
//  Created by 范新 on 2018/6/12.
//

public extension UITableViewHeaderFooterView {

    static var nib:UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

    static var reuseIdentifier: String {
        return String(describing: self)
    }

}
