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

extension CAKeyframeAnimation {

    /// 选中的动画
    static var imagePickingButtonSelectedAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.3
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.values = [NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0)),
                            NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),
                            NSValue(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 1.0)),
                            NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))]
        return animation
    }()

}

extension UIViewController {

    var imagePickerController: LavenderImagePickerController? {
        return navigationController as? LavenderImagePickerController
    }

}
