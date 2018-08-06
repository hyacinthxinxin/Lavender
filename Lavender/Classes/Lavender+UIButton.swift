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

    func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        base.targetClosure = closure
        base.addTarget(base, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }

}

extension UIButton {

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = self.enlargedRect
        if rect.equalTo(self.bounds) {
            return super.hitTest(point, with: event)
        }
        return rect.contains(point) ? self : nil
    }

    var enlargedRect: CGRect {
        if let topEdge = objc_getAssociatedObject(self, &topNameKey) as? NSNumber,
            let leftEdge = objc_getAssociatedObject(self, &leftNameKey) as? NSNumber,
            let bottomEdge = objc_getAssociatedObject(self, &bottomNameKey) as? NSNumber,
            let rightEdge = objc_getAssociatedObject(self, &rightNameKey) as? NSNumber {
            return CGRect(x: self.bounds.origin.x - CGFloat(leftEdge.floatValue), y: self.bounds.origin.y - CGFloat(topEdge.floatValue), width: self.bounds.size.width + CGFloat(leftEdge.floatValue) + CGFloat(rightEdge.floatValue), height: self.bounds.size.height + CGFloat(topEdge.floatValue) + CGFloat(bottomEdge.floatValue))
        } else {
            return self.bounds
        }
    }

}

/*
 loginButton.addTargetClosure { _ in

 // login logics

 }

 */

public typealias UIButtonTargetClosure = (UIButton) -> ()

public class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}

public extension UIButton {

    public struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }

    public var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc public func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }

}
