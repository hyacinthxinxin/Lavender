//
//  LavenderImagePickerController.swift
//  Lavender
//
//  Created by 范新 on 2018/6/6.
//

import UIKit
import Photos

public struct LavenderImagePickerControllerInfoKey {
    public static let pickedAssetList = "com.xiaoxiangyeyu.hn.lavender.imagePickerController.pickedAssetList"
    public static let pickedImages = "com.xiaoxiangyeyu.hn.lavender.imagePickerController.pickedImages"
}

public protocol LavenderImagePickerControllerDelegate: UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: LavenderImagePickerController)

    func imagePickerController(_ picker: LavenderImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])

}

public class LavenderImagePickerController: UINavigationController {

    weak var imagePickerDelegate: LavenderImagePickerControllerDelegate?

    public var barTintColor: UIColor = UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1)

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

    public var pickedAssetList: LavenderImagePickerPickedAssetList = LavenderImagePickerPickedAssetList()

    public override var delegate: UINavigationControllerDelegate? {
        didSet {
            imagePickerDelegate = delegate as? LavenderImagePickerControllerDelegate
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

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }

    /// 初始化
    convenience public init() {
        self.init(navigationBarClass: nil, toolbarClass: nil)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barStyle = .black
        self.navigationBar.setBackgroundImage(UIImage(color: barTintColor), for: .default)
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = UIColor.gray
        self.pickedAssetList.controller = self

        switch sourceType {
        case .photoLibrary, .savedPhotosAlbum:
            self.setViewControllers([LavenderImagePickerAlbumViewController()], animated: false)
        case .camera:
            self.setViewControllers([LavenderImagePickerCameraViewController()], animated: false)
        }
    }

}
