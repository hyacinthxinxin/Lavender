//
//  LavenderImagePickerAlbumViewController.swift
//  Lavender
//
//  Created by 范新 on 2018/6/6.
//

import UIKit
import Photos

class LavenderImagePickerAlbumViewController: UIViewController {

    weak public var imagePickerDelegate: LavenderImagePickerControllerDelegate?

    weak var controller :LavenderImagePickerController?

    var albumList: LavenderImagePickerAlbumList?

//    var assetCollections = [PHAssetCollection]()

    lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.lightGray
        $0.separatorStyle = .singleLine
        $0.estimatedRowHeight = LavenderImagePickerAlbumCell.firstImageViewHeight+0.01
        $0.rowHeight = UITableViewAutomaticDimension
        $0.dataSource = self
        $0.delegate = self
        $0.tableFooterView = UIView()
        return $0
    }(UITableView(frame: CGRect.zero, style: .plain))

    deinit {
        LVU.logging(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        tableView.register(LavenderImagePickerAlbumCell.self, forCellReuseIdentifier: LavenderImagePickerAlbumCell.reuseIdentifier)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            guard let `self` = self else { return }
//            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
//            smartAlbums.enumerateObjects({ (collection, _, _) in
//                self.assetCollections.append(collection)
//            })
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }

    @objc fileprivate func cancel() {
        guard let imagePickerController = self.navigationController as? LavenderImagePickerController else {
            return
        }
        imagePickerDelegate?.imagePickerControllerDidCancel(imagePickerController)
    }

}

extension LavenderImagePickerAlbumViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let albumList = self.albumList else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: LavenderImagePickerAlbumCell.reuseIdentifier, for: indexPath) as! LavenderImagePickerAlbumCell
        let album = albumList[indexPath.row]
        cell.titleLabel.text = album.title
        cell.tag = indexPath.row
        cell.countLabel.text = "（\(album.count)）"
//        cell.config(with: assetCollections[indexPath.row])
        return cell
    }

}

extension LavenderImagePickerAlbumViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let assetCollection = assetCollections[indexPath.row]
//        let option = PHFetchOptions()
//        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
//        option.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)
//        let result = PHAsset.fetchAssets(in: assetCollection, options: option)
//        var assets = [PHAsset]()
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            guard let `self` = self else { return }
//            result.enumerateObjects({ (asset, _, _) in
//                assets.append(asset)
//            })
//            DispatchQueue.main.async {
//                let imagePickerThumbnailViewController = LavenderImagePickerThumbnailViewController(imagePickerDelegate: self.imagePickerDelegate)
//                imagePickerThumbnailViewController.assets = assets
//                self.navigationController?.pushViewController(imagePickerThumbnailViewController, animated: true)
//                tableView.deselectRow(at: indexPath, animated: true)
//            }
//        }
        let assetList = albumList?[indexPath.row]
        let imagePickerThumbnailViewController = LavenderImagePickerThumbnailViewController(imagePickerDelegate: imagePickerDelegate)
        imagePickerThumbnailViewController.controller = controller
        imagePickerThumbnailViewController.assetList = assetList
        navigationController?.pushViewController(imagePickerThumbnailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
