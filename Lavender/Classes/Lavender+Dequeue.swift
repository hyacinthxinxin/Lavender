//
//  Lavender+Dequeue.swift
//  Lavender
//
//  Created by 范新 on 2018/6/15.
//

public extension UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}

public extension UICollectionReusableView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}

public extension UITableViewHeaderFooterView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
}
