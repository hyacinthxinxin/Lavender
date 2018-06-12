//
//  LavenderImagePickerThumbnailCell.swift
//  Lavender
//
//  Created by 范新 on 2018/6/7.
//

import UIKit
import Photos

class LavenderImagePickerThumbnailCell: UICollectionViewCell {

    var identifier: String?

    var imageRequestID: PHImageRequestID?

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var selectButton: UIButton = { [unowned self] in
        let button = UIButton(type: .custom)
        button.setBackgroundImage(LavenderImagePickerResource.thumbnailCellUnselectedImage, for: UIControlState())
        button.setBackgroundImage(LavenderImagePickerResource.thumbnailCellSelectedImage, for: .selected)
        button.lv.setEnlargeEdge(top: 0, left: 20, bottom: 20, right: 0)
        return button
        }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(selectButton)
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        selectButton.frame = CGRect(x: self.bounds.size.width - 26, y: 5, width: 23, height: 23)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with asset: PHAsset) {

        let size = CGSize(width: self.frame.size.width * 1.7, height: self.frame.size.height * 1.7)
        identifier = asset.localIdentifier
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .fastFormat
        requestOptions.isNetworkAccessAllowed = true

        PHCachingImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { [weak self] image, info in
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

}
