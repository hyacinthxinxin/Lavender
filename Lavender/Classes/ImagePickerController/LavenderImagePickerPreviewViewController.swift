//
//  LavenderImagePickerPreviewViewController.swift
//  Lavender
//
//  Created by 范新 on 2018/6/6.
//

import UIKit
import Photos

class LavenderImagePickerPreviewViewController: UIViewController {

    weak public var imagePickerDelegate: LavenderImagePickerControllerDelegate?

    weak var controller :LavenderImagePickerController?

    var assetList: LavenderImagePickerAssetList?

    var isFirstAppearance = true

    lazy var collectionView: UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: LavenderImagePickerPreviewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
        }()

    lazy var selectButton: UIButton = { [unowned self] in
        let button = UIButton(type: .custom)
        button.setImage(LavenderImagePickerResource.thumbnailCellUnselectedImage, for: .normal)
        button.setImage(LavenderImagePickerResource.thumbnailCellSelectedImage, for: .selected)
        button.addTarget(self, action: #selector(didClickSelectButton(_:)), for: .touchUpInside)
        return button
        }()

    var currentIndexPath: IndexPath = IndexPath() {
        willSet {
            if currentIndexPath != newValue {
                didChangePreviewPage(newValue)
            }
        }
    }

    deinit {
        LVU.logging(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        collectionView.register(LavenderImagePickerPreviewCell.self, forCellWithReuseIdentifier: LavenderImagePickerPreviewCell.reuseIdentifier)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: selectButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollCollectionViewToInitialPosition()
    }

    @objc fileprivate func didClickSelectButton(_ sender: UIButton) {
        guard let controller = self.controller else { return }
        guard let assetList = self.assetList else { return }
        let asset = assetList[currentIndexPath.item]
        if selectButton.isSelected {
            if controller.pickedAssetList.drop(asset: asset) {
                selectButton.isSelected = false
            }
        } else {
            if controller.pickedAssetList.pick(asset: asset) {
                selectButton.isSelected = true
            }
        }
    }

    fileprivate func didChangePreviewPage(_ indexPath: IndexPath) {
        guard let controller = self.controller else { return }
        guard let assetList = self.assetList else { return }
        let asset = assetList[indexPath.item]
        selectButton.isSelected = controller.pickedAssetList.isPicked(asset)
    }

    fileprivate func scrollCollectionViewToInitialPosition() {
        guard isFirstAppearance else { return }
        let indexPath = IndexPath(row: currentIndexPath.item, section: 0)
        scrollCollectionView(to: indexPath)
        isFirstAppearance = false
    }

    func scrollCollectionView(to indexPath: IndexPath) {
        guard let assetList = self.assetList, assetList.count > 0 else { return }
        DispatchQueue.main.async {
            let toIndexPath = IndexPath(item: indexPath.item, section: 0)
            self.collectionView.scrollToItem(at: toIndexPath, at: .centeredHorizontally, animated: false)
        }
    }

}

extension LavenderImagePickerPreviewViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let assetList = self.assetList else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LavenderImagePickerPreviewCell.reuseIdentifier, for: indexPath) as! LavenderImagePickerPreviewCell
//        cell.config(with: assets[indexPath.item])
        let asset = assetList[indexPath.item]
        cell.tag = indexPath.item
        let targetSize = CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale, height: UIScreen.main.bounds.width * UIScreen.main.scale)
        asset.requestPreviewImage(targetSize: targetSize) { (image, _) in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        return cell
    }

}

extension LavenderImagePickerPreviewViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let row = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if row < 0 {
            currentIndexPath = IndexPath(row: 0, section: currentIndexPath.section)
        } else if row >= collectionView.numberOfItems(inSection: 0) {
            currentIndexPath = IndexPath(row: collectionView.numberOfItems(inSection: 0) - 1, section: currentIndexPath.section)
        } else {
            currentIndexPath = IndexPath(row: row, section: currentIndexPath.section)
        }
        /*   let offsetX = scrollView.contentOffset.x
         let width = scrollView.frame.width
         self.currentModelIndex = Int(offsetX / width)*/
    }

}
