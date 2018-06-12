//
//  LavenderImagePickerAlbumViewController.swift
//  Lavender
//
//  Created by 范新 on 2018/6/6.
//

import UIKit
import Photos

class LavenderImagePickerAlbumViewController: UIViewController {

    var albumList: LavenderImagePickerAlbumList?

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
        guard let imagePickerController = self.imagePickerController else { return }
        prepareNavigationItems()
        tableView.register(LavenderImagePickerAlbumCell.self, forCellReuseIdentifier: LavenderImagePickerAlbumCell.reuseIdentifier)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        albumList = LavenderImagePickerAlbumList(
                assetCollectionTypes: imagePickerController.assetCollectionTypes,
                assetCollectionSubtypes: imagePickerController.assetCollectionSubtypes,
                mediaType: imagePickerController.mediaType,
                shouldShowEmptyAlbum: imagePickerController.shouldShowEmptyAlbum,
                handler: { [weak self] in
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        guard imagePickerController.sourceType == .savedPhotosAlbum else { return }
                        if let assetList = self?.albumList?.first(where: { $0.assetList.assetCollectionSubtype == PHAssetCollectionSubtype.smartAlbumUserLibrary }) {
                            self?.showImagePickerThumbnailViewController(with: assetList)
                        }
                    }
            })
    }

    fileprivate func prepareNavigationItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
    }

    fileprivate func showImagePickerThumbnailViewController(with ablum: LavenderImagePickerAssetList) {
        let imagePickerThumbnailViewController = LavenderImagePickerThumbnailViewController(nibName: nil, bundle: nil)
        imagePickerThumbnailViewController.assetList = ablum
        navigationController?.pushViewController(imagePickerThumbnailViewController, animated: false)
    }

    @objc fileprivate func cancel() {
        guard let imagePickerController = self.imagePickerController else { return }
        imagePickerController.imagePickerDelegate?.imagePickerControllerDidCancel(imagePickerController)
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
        guard let albumList = self.albumList else { return }
        showImagePickerThumbnailViewController(with: albumList[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
