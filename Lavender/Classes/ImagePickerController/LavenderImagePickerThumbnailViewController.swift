//
//  LavenderImagePickerThumbnailViewController.swift
//  Lavender
//
//  Created by 范新 on 2018/6/6.
//

import UIKit
import Photos

fileprivate let cellPadding: CGFloat = 6

fileprivate let lineCount: Int = 4

class LavenderImagePickerThumbnailViewController: UIViewController {

    var assetList: LavenderImagePickerAssetList?

    var notifications: [NSObjectProtocol?]?

    deinit {
        LVU.logging(self)
        removeNotification()
    }

    func removeNotification() {
        if let notifications = self.notifications {
            _ = notifications.map {
                NotificationCenter.default.removeObserver($0 as Any)
            }
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: cellPadding, left: cellPadding, bottom: cellPadding, right: cellPadding)
        collectionViewFlowLayout.minimumLineSpacing = cellPadding
        collectionViewFlowLayout.minimumInteritemSpacing = cellPadding
        let width = (UIScreen.main.bounds.size.width - cellPadding * (CGFloat(lineCount) + 1)) / CGFloat(lineCount)
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: width)
        return collectionViewFlowLayout
    }()

    lazy var collectionView: UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
        }()

    lazy var toolbar: LavenderImagePickerThumbnailToolbar = {
        $0.backgroundColor = UIColor.white
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(LavenderImagePickerThumbnailToolbar(frame: CGRect.zero))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.brown
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        collectionView.register(LavenderImagePickerThumbnailCell.self, forCellWithReuseIdentifier: LavenderImagePickerThumbnailCell.reuseIdentifier)
        view.addSubview(collectionView)
        toolbar.controller = imagePickerController
        view.addSubview(toolbar)

        if #available(iOS 11.0, *) {
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            toolbar.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44)
            ])
        notifications = [
            NotificationCenter.default.addObserver(forName: NotificationInfo.Asset.PhotoKit.didPick, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
                LVU.logging("Need Reload Data")
                guard self?.navigationController?.topViewController != self else { return }
                self?.collectionView.reloadData()
            },
            NotificationCenter.default.addObserver(forName: NotificationInfo.Asset.PhotoKit.didDrop, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
                guard self?.navigationController?.topViewController != self else { return }
                self?.collectionView.reloadData()
            }
        ]
    }

    @objc fileprivate func cancel() {
        guard let imagePickerController = self.imagePickerController else { return }
        imagePickerController.imagePickerDelegate?.imagePickerControllerDidCancel(imagePickerController)
    }

}

extension LavenderImagePickerThumbnailViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imagePickerController = self.imagePickerController, let assetList = self.assetList else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LavenderImagePickerThumbnailCell.reuseIdentifier, for: indexPath) as! LavenderImagePickerThumbnailCell
        let asset = assetList[indexPath.item]
        cell.tag = indexPath.item

        let isPickedWithIndex = imagePickerController.pickedAssetList.isPickedWithIndex(asset)
        if isPickedWithIndex.0 {
            cell.selectButton.isSelected = true
            cell.selectButton.setTitle("\(isPickedWithIndex.index!)", for: .selected)
        } else {
            cell.selectButton.isSelected = false
        }
//        cell.selectButton.isSelected = controller.pickedAssetList.isPicked(asset)
//        self.overlayView.isHidden = !pickButton.isSelected
        let targetSize = CGSize(width: collectionViewFlowLayout.itemSize.width * UIScreen.main.scale, height: collectionViewFlowLayout.itemSize.height * UIScreen.main.scale)
        asset.requestThumbnailImage(targetSize: targetSize) { (image, _) in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        cell.selectButton.addTarget(self, action: #selector(didClickPickButton(_:)), for: .touchUpInside)
        return cell
    }

    @objc fileprivate func didClickPickButton(_ sender: UIButton) {
        guard let imagePickerController = self.imagePickerController else { return }
        guard let clickIndexPath = collectionView.indexPathForItem(at: sender.convert(CGPoint.zero, to: collectionView)) else { return }
        guard let clickAsset = assetList?[clickIndexPath.item] else { return }
        if sender.isSelected {
            if imagePickerController.pickedAssetList.drop(asset: clickAsset) {
                sender.isSelected = false
            }
        } else {
            if imagePickerController.pickedAssetList.pick(asset: clickAsset) {
                sender.isSelected = true
                sender.layer.add(CAKeyframeAnimation.imagePickingButtonSelectedAnimation, forKey: nil)
            }
        }
    }

}

extension LavenderImagePickerThumbnailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imagePickerPreviewViewController = LavenderImagePickerPreviewViewController(nibName: nil, bundle: nil)
        imagePickerPreviewViewController.assetList = assetList
        imagePickerPreviewViewController.currentIndexPath = indexPath
        navigationController?.pushViewController(imagePickerPreviewViewController, animated: true)
    }

}
