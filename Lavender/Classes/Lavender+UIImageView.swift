//
//  UIImageView+Lavender.swift
//  Alamofire
//
//  Created by 范新 on 2018/5/31.
//

//extension Lavender where Base: UIImageView {
//
//    public func applyThemeImage() {
//        base.image = UIImage(named: "test.jpg", in: LavenderBundle.resourceBundle, compatibleWith: nil)
//    }
//
//}

import Foundation
import UIKit
import QuartzCore

public extension UIImageView {

    /**
     Loads an image from a URL. If cached, the cached image is returned. Otherwise, a place holder is used until the image from web is returned by the closure.

     - Parameter url: The image URL.
     - Parameter placeholder: The placeholder image.
     - Parameter fadeIn: Weather the mage should fade in.
     - Parameter closure: Returns the image from the web the first time is fetched.

     - Returns A new image
     */
    func imageFromURL(_ url: String, placeholder: UIImage, fadeIn: Bool = true, shouldCacheImage: Bool = true, closure: ((_ image: UIImage?) -> ())? = nil) {
        self.image = UIImage.image(fromURL: url, placeholder: placeholder, shouldCacheImage: shouldCacheImage) {
            (image: UIImage?) in
            if image == nil {
                return
            }
            self.image = image
            if fadeIn {
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionFade
                self.layer.add(transition, forKey: nil)
            }
            closure?(image)
        }
    }


}
