//
//  LavenderImagePickerController.swift
//  Lavender
//
//  Created by 范新 on 2018/6/6.
//

import UIKit
import Photos

public protocol LavenderImagePickerControllerDelegate: UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: LavenderImagePickerController)
}

public class LavenderImagePickerController: UINavigationController {

    weak var imagePickerDelegate: LavenderImagePickerControllerDelegate?

    public var maximumNumberOfSelection: Int = 9

    public var sourceType: LavenderImagePickerControllerSourceType = .photoLibrary

    public var assetCollectionTypes = [PHAssetCollectionType.smartAlbum, PHAssetCollectionType.album]

    public var assetCollectionSubtypes: [PHAssetCollectionSubtype] = [
        .albumRegular,
        .albumSyncedEvent,
        .albumSyncedFaces,
        .albumSyncedAlbum,
        .albumImported,
        .albumMyPhotoStream,
        .albumCloudShared,
        .smartAlbumGeneric,
        .smartAlbumFavorites,
        .smartAlbumRecentlyAdded,
        .smartAlbumUserLibrary
    ]

    public var mediaType: LavenderImagePickerControllerMediaType = .photo

    public var shouldShowEmptyAlbum = true

    var pickedAssetList: LavenderImagePickerPickedAssetList = LavenderImagePickerPickedAssetList()

    public override var delegate: UINavigationControllerDelegate? {
        didSet {
            imagePickerDelegate = delegate as? LavenderImagePickerControllerDelegate
            guard let albumViewController = self.topViewController as? LavenderImagePickerAlbumViewController else {
                return
            }
            albumViewController.imagePickerDelegate = imagePickerDelegate
            if sourceType == .photoLibrary || sourceType == .savedPhotosAlbum {
                albumViewController.controller = self
                albumViewController.albumList =
                    LavenderImagePickerAlbumList(
                        assetCollectionTypes: assetCollectionTypes,
                        assetCollectionSubtypes: assetCollectionSubtypes,
                        mediaType: mediaType,
                        shouldShowEmptyAlbum: shouldShowEmptyAlbum,
                        handler: { [weak albumViewController] in
                            DispatchQueue.main.async { [weak self] in
                                albumViewController?.tableView.reloadData()
                                guard let `self` = self else { return }
                                if self.sourceType == .savedPhotosAlbum {
                                    let assetList = albumViewController?.albumList?.first(where: {
                                        $0.assetList.assetCollectionSubtype == PHAssetCollectionSubtype.smartAlbumUserLibrary
                                    })
                                    let imagePickerThumbnailViewController = LavenderImagePickerThumbnailViewController(imagePickerDelegate: self.imagePickerDelegate)
                                    imagePickerThumbnailViewController.controller = self
                                    imagePickerThumbnailViewController.assetList = assetList
                                    self.pushViewController(imagePickerThumbnailViewController, animated: false)
                                }
                            }
                    })
            }
        }
    }

    deinit {
        LVU.logging(self)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience public init() {
        self.init(rootViewController: LavenderImagePickerAlbumViewController())
        self.pickedAssetList.controller = self
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
//        self.setViewControllers([LavenderImagePickerAlbumViewController()], animated: false)
    }

}
