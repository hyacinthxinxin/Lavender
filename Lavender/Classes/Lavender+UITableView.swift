//
//  Lavender+UITableView.swift
//  Lavender
//
//  Created by 范新 on 2018/6/11.
//

fileprivate var lv_originalFrame = "com.lavender.tableView.originalFrame"
fileprivate var lv_imageView = "com.lavender.tableView.imageView"

extension Lavender where Base: UITableView {

    open func setHeaderView(frame: CGRect, image: UIImage?) {
        objc_setAssociatedObject(base, &lv_originalFrame, frame, .OBJC_ASSOCIATION_RETAIN)
        let bgImageView = UIImageView(frame: frame)
        bgImageView.clipsToBounds = true
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = image
        base.insertSubview(bgImageView, at: 0)
        objc_setAssociatedObject(base, &lv_imageView, bgImageView, .OBJC_ASSOCIATION_RETAIN)
    }

}

extension UITableView {

    open override var contentOffset: CGPoint {
        didSet {
            if let originalFrame = objc_getAssociatedObject(self, &lv_originalFrame) as? CGRect,
                let imageView = objc_getAssociatedObject(self, &lv_imageView) as? UIImageView {
                let offsetY = contentOffset.y
                if offsetY < 0 {
                    imageView.frame = CGRect(x: offsetY / 2, y: offsetY, width: originalFrame.size.width - offsetY, height: originalFrame.size.height - offsetY)
                } else {
                    imageView.frame = originalFrame
                }
            }
        }
    }

    open var bgImageView: UIImageView? {
        return objc_getAssociatedObject(self, &lv_imageView) as? UIImageView
    }

}
