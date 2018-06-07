//
//  LavenderImagePickerPreviewCell.swift
//  Lavender
//
//  Created by 范新 on 2018/6/7.
//

import UIKit
import Photos

class LavenderImagePickerPreviewCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: LavenderImagePickerPreviewCell.self)

    var identifier: String?

    var imageRequestID: PHImageRequestID?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var imageMaximumZoomScale: CGFloat = 2.0 {
        didSet {
            self.scrollView.maximumZoomScale = imageMaximumZoomScale
        }
    }

    var imageZoomScaleForDoubleTap: CGFloat = 2.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.delegate = self
        scrollView.maximumZoomScale = imageMaximumZoomScale
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)

        scrollView.addSubview(imageView)
        // 双击手势
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = contentView.bounds
        imageView.frame = contentView.bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with asset: PHAsset) {
        let size = CGSize(width: self.frame.size.width * min(UIScreen.main.scale, 2.0), height: self.frame.size.height * min(UIScreen.main.scale, 2.0))
        identifier = asset.localIdentifier
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        PHCachingImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFit, options: requestOptions) { [weak self] image, info in
            guard let `self` = self else { return }
            if self.identifier!.elementsEqual(asset.localIdentifier) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            if let info = info, let isDegraded = info[PHImageResultIsDegradedKey] as? Bool, !isDegraded {
                self.imageRequestID = -1
            }
        }
    }

    /// 响应双击
    @objc fileprivate func onDoubleTap(_ dbTap: UITapGestureRecognizer) {
        // 如果当前没有任何缩放，则放大到目标比例
        // 否则重置到原比例
        if scrollView.zoomScale == 1.0 {
            // 以点击的位置为中心，放大
            let pointInView = dbTap.location(in: imageView)
            let w = scrollView.bounds.size.width / imageZoomScaleForDoubleTap
            let h = scrollView.bounds.size.height / imageZoomScaleForDoubleTap
            let x = pointInView.x - (w / 2.0)
            let y = pointInView.y - (h / 2.0)
            scrollView.zoom(to: CGRect(x: x, y: y, width: w, height: h), animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }

}

extension LavenderImagePickerPreviewCell: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(centerOfContentSize)
        imageView.center = centerOfContentSize
    }

    /// 计算contentSize应处于的中心位置
    private var centerOfContentSize: CGPoint {
        let deltaWidth = bounds.width - scrollView.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = bounds.height - scrollView.contentSize.height
        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
        return CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                       y: scrollView.contentSize.height * 0.5 + offsetY)
    }

}
