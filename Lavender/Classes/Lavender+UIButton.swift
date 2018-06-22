//
//  UIButton+Lavender.swift
//  Lavender
//
//  Created by 范新 on 2018/6/1.
//


fileprivate var topNameKey: String = "topNameKey"
fileprivate var leftNameKey: String = "leftNameKey"
fileprivate var bottomNameKey: String = "bottomNameKey"
fileprivate var rightNameKey: String = "rightNameKey"

public extension Lavender where Base: UIButton {

    func setEnlargeEdge(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        objc_setAssociatedObject(base, &topNameKey, NSNumber(value: Float(top)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(base, &leftNameKey, NSNumber(value: Float(left)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(base, &bottomNameKey, NSNumber(value: Float(bottom)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(base, &rightNameKey, NSNumber(value: Float(right)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    var enlargedRect: CGRect {
        if let topEdge = objc_getAssociatedObject(base, &topNameKey) as? NSNumber,
            let leftEdge = objc_getAssociatedObject(base, &leftNameKey) as? NSNumber,
            let bottomEdge = objc_getAssociatedObject(base, &bottomNameKey) as? NSNumber,
            let rightEdge = objc_getAssociatedObject(base, &rightNameKey) as? NSNumber {
            return CGRect(x: base.bounds.origin.x - CGFloat(leftEdge.floatValue), y: base.bounds.origin.y - CGFloat(topEdge.floatValue), width: base.bounds.size.width + CGFloat(leftEdge.floatValue) + CGFloat(rightEdge.floatValue), height: base.bounds.size.height + CGFloat(topEdge.floatValue) + CGFloat(bottomEdge.floatValue))
        } else {
            return base.bounds
        }
    }

}

extension UIButton {

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = self.lv.enlargedRect
        if rect.equalTo(self.bounds) {
            return super.hitTest(point, with: event)
        }
        return rect.contains(point) ? self : nil
    }

}
