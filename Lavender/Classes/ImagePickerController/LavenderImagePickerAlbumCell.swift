//
//  LavenderImagePickerAlbumCell.swift
//  Lavender
//
//  Created by 范新 on 2018/6/7.
//

import UIKit
import Photos

extension LavenderImagePickerAlbumCell {
    static let firstImageViewHeight: CGFloat = 82
}

class LavenderImagePickerAlbumCell: UITableViewCell {

    lazy var firstImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView(frame: CGRect.zero))

    lazy var titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        $0.textColor = UIColor.black
        return $0
    }(UILabel(frame: CGRect.zero))

    lazy var countLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = UIColor.lightGray
        return $0
    }(UILabel(frame: CGRect.zero))

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.addSubview(firstImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        prepareAutoLayout()
    }

    fileprivate func prepareAutoLayout() {
        let views = [
            "firstImageView": firstImageView,
            "titleLabel": titleLabel,
            "countLabel": countLabel,
            ]
        let metrics = [
            "horizontalPadding": 8,
            "firstImageViewWidth": LavenderImagePickerAlbumCell.firstImageViewHeight
        ]
        var allConstraints: [NSLayoutConstraint] = []
        let firstImageViewVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[firstImageView(firstImageViewWidth@999)]-0-|",
            metrics: metrics,
            views: views)
        allConstraints += firstImageViewVerticalConstraints
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[firstImageView(firstImageViewWidth)]-horizontalPadding-[titleLabel]-horizontalPadding-[countLabel]",
            options: [.alignAllCenterY],
            metrics: metrics,
            views: views)
        allConstraints += horizontalConstraints
        NSLayoutConstraint.activate(allConstraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with assetCollection: PHAssetCollection) {
        print(assetCollection.assetCollectionType.rawValue)
        print(assetCollection.assetCollectionSubtype.rawValue)
        titleLabel.text = assetCollection.localizedTitle
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        option.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)
        let assets = PHAsset.fetchAssets(in: assetCollection, options: option)
        countLabel.text = "（\(assets.count)）"
        if let firstAsset = assets.firstObject {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                PHCachingImageManager.default().requestImage(for: firstAsset, targetSize: CGSize(width: 52, height: 52), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, info) in
//                    print(image)
//                    print(info)
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        self.firstImageView.image = image
                    }
                }
            }
        }
    }

}
