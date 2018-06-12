//
//  UITableView+Lavender.swift
//  Lavender
//
//  Created by 范新 on 2018/6/5.
//


public extension UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var nib:UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

    func adjustSeparatorInset(_ margin: CGFloat = 15) {
        if responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            separatorInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        }
        if responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            preservesSuperviewLayoutMargins = false
        }
        if responds(to: #selector(setter: UIView.layoutMargins)) {
            layoutMargins = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        }
    }

}
