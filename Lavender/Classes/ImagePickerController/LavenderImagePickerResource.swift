//
//  LavenderImagePickerControllerAsset.swift
//  Lavender
//
//  Created by 范新 on 2018/6/7.
//

import Foundation

struct LavenderImagePickerResource {

    static var thumbnailCellSelectedImage: UIImage? {
        return UIImage(named: "btn_selected", in: LavenderBundle.resourceBundle, compatibleWith: nil)
    }

    static var thumbnailCellUnselectedImage: UIImage? {
        return UIImage(named: "btn_unselected", in: LavenderBundle.resourceBundle, compatibleWith: nil)
    }

}
