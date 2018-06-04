//
//  UIImageView+Lavender.swift
//  Alamofire
//
//  Created by 范新 on 2018/5/31.
//

extension Lavender where Base: UIImageView {

    public func applyThemeImage() {
        base.image = UIImage(named: "test.jpg", in: LavenderBundle.resourceBundle, compatibleWith: nil)
    }

}
