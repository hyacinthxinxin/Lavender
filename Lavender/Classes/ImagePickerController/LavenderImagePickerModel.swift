//
//  LavenderImagePickerModel.swift
//  Lavender
//
//  Created by 范新 on 2018/6/7.
//

import Foundation
import Photos

public enum LavenderImagePickerControllerSourceType: Int {
    case photoLibrary = 0, camera, savedPhotosAlbum
}

public enum LavenderImagePickerControllerMediaType: Int {
    case any = 0, photo, video
}

public class LavenderImagePickerAsset {

    let asset: PHAsset

    public init(asset: PHAsset) {
        self.asset = asset
    }

    public var originalAsset: PHAsset {
        return asset as PHAsset
    }

    public var identifier: Int {
        return asset.localIdentifier.hash
    }

    public func requestThumbnailImage(targetSize: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Swift.Void) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .fastFormat
        requestOptions.isNetworkAccessAllowed = true
        PHCachingImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, info in
            resultHandler(image, info)
        }
    }

    public func requestPreviewImage(targetSize: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Swift.Void) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        PHCachingImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: requestOptions) { image, info in
            resultHandler(image, info)
        }
    }

}


/// 列表协议
public protocol LavenderImagePickerListType: Collection {
    associatedtype Item
    var title: String { get }
    func update(_ handler:(() -> Void)?)
    subscript (index: Int) -> Item { get }
}

extension LavenderImagePickerListType {
    public func index(after i: Int) -> Int {
        return i + 1
    }
}


/// 选择的资源列表
class LavenderImagePickerPickedAssetList: LavenderImagePickerListType {

    var assetList: [Item] = []

    weak var controller :LavenderImagePickerController?

    typealias Item = LavenderImagePickerAsset

    var title: String {
        return "Selected Assets"
    }

    func update(_ handler:(() -> Void)?) {
        fatalError("not supported")
    }

    subscript (index: Int) -> Item {
        return assetList[index]
    }

    // MARK: - CollectionType

    var startIndex: Int {
        return 0
    }

    var endIndex: Int {
        return assetList.count
    }

    func isPicked(_ asset: LavenderImagePickerAsset) -> Bool {
        return assetList.contains { $0.identifier == asset.identifier }
    }

    func pick(asset: LavenderImagePickerAsset) -> Bool {
        guard !isPicked(asset) else { return false }
        let assetsCountBeforePicking = self.count
        guard let controller = self.controller, assetsCountBeforePicking < controller.maximumNumberOfSelection  else {
            return false
        }
        assetList.append(asset)
        for asset in assetList {
            LVU.logging(asset.identifier)
        }
        LVU.logging(asset.identifier)
        LVU.logging(assetList.index(where: { $0.identifier == asset.identifier }))
        let assetsCountAfterPicking = self.count
        NotificationCenter.default.post(
            Notification(
                name: NotificationInfo.Asset.PhotoKit.didPick,
                object: nil,
                userInfo: [
                    NotificationInfo.Asset.PhotoKit.didPickUserInfoKeyAsset: asset.originalAsset,
                    NotificationInfo.Asset.PhotoKit.didPickUserInfoKeyPickedAssetsCount: assetsCountAfterPicking
                ]
            )
        )
        return true
    }

    func drop(asset: LavenderImagePickerAsset) -> Bool {
//        let assetsCountBeforeDropping = self.count
        LVU.logging(assetList.index(where: { $0.identifier == asset.identifier }))
        assetList = assetList.filter { $0.identifier != asset.identifier }
        let assetsCountAfterDropping = self.count
        NotificationCenter.default.post(
            Notification(
                name: NotificationInfo.Asset.PhotoKit.didDrop,
                object: nil,
                userInfo: [
                    NotificationInfo.Asset.PhotoKit.didDropUserInfoKeyAsset : asset.originalAsset,
                    NotificationInfo.Asset.PhotoKit.didDropUserInfoKeyPickedAssetsCount : assetsCountAfterDropping
                ]
            )
        )
        return true
    }

}

/// 资源列表
public class LavenderImagePickerAssetList: LavenderImagePickerListType {

    fileprivate let mediaType: LavenderImagePickerControllerMediaType

    public let assetList: PHAssetCollection

    fileprivate var fetchResult: PHFetchResult<PHAsset>!

    init(album: PHAssetCollection, mediaType: LavenderImagePickerControllerMediaType) {
        self.assetList = album
        self.mediaType = mediaType
        update()
    }

    public typealias Item = LavenderImagePickerAsset

    open var title: String {
        return assetList.localizedTitle ?? ""
    }

    open var date: Date? {
        return assetList.startDate
    }

    static func fetchOptions(_ mediaType: LavenderImagePickerControllerMediaType) -> PHFetchOptions {
        let options = PHFetchOptions()
        switch mediaType {
        case .photo:
            options.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)
        default:
            fatalError("not supported .Video and .Any yet")
        }
        return options
    }

    open func update(_ handler: (() -> Swift.Void)? = nil) {
        fetchResult = PHAsset.fetchAssets(in: assetList, options: LavenderImagePickerAssetList.fetchOptions(mediaType))
        if let handler = handler {
            handler()
        }
    }

    open subscript (index: Int) -> Item {
        return Item(asset: fetchResult.object(at: index))
    }

    // MARK: - CollectionType

    open var startIndex: Int {
        return 0
    }

    open var endIndex: Int {
        return fetchResult.count
    }

}

/// 相册列表
public class LavenderImagePickerAlbumList: LavenderImagePickerListType {

    private var albumList: [Item] = []

    private let assetCollectionTypes: [PHAssetCollectionType]

    private let assetCollectionSubtypes: [PHAssetCollectionSubtype]

    private let mediaType: LavenderImagePickerControllerMediaType

    private var shouldShowEmptyAlbum: Bool

    // MARK: - init

    init(assetCollectionTypes: [PHAssetCollectionType], assetCollectionSubtypes: [PHAssetCollectionSubtype], mediaType: LavenderImagePickerControllerMediaType, shouldShowEmptyAlbum: Bool, handler:(() -> Swift.Void)?) {
        self.assetCollectionTypes = assetCollectionTypes
        self.assetCollectionSubtypes = assetCollectionSubtypes
        self.mediaType = mediaType
        self.shouldShowEmptyAlbum = shouldShowEmptyAlbum
        update { () -> Void in
            if let handler = handler {
                handler()
            }
        }
    }

    public typealias Item = LavenderImagePickerAssetList

    open var title: String {
        return "Lavender Image Picker"
    }

    open func update(_ handler:(() -> Void)?) {
        DispatchQueue.global(qos: .default).async {
            var albumListFetchResult: [PHFetchResult<PHAssetCollection>] = []
            for type in self.assetCollectionTypes {
                albumListFetchResult = albumListFetchResult + [PHAssetCollection.fetchAssetCollections(with: type, subtype: .any, options: nil)]
            }
            self.albumList = []
            var tmpAlbumList: [Item] = []
            let isAssetCollectionSubtypeAny = self.assetCollectionSubtypes.contains(.any)
            for fetchResult in albumListFetchResult {
                fetchResult.enumerateObjects({ (album, index, stop) in
                    if self.assetCollectionSubtypes.contains(album.assetCollectionSubtype) || isAssetCollectionSubtypeAny {
                        if self.shouldShowEmptyAlbum || PHAsset.fetchAssets(in: album, options: LavenderImagePickerAssetList.fetchOptions(self.mediaType)).count != 0 {
                            tmpAlbumList.append(LavenderImagePickerAssetList(album: album, mediaType: self.mediaType))
                        }
                    }
                })
            }
            if self.assetCollectionTypes == [.moment] {
                self.albumList =  tmpAlbumList.sorted { $0.date!.timeIntervalSince1970 < $1.date!.timeIntervalSince1970 }
            } else {
                self.albumList =  tmpAlbumList
            }
            if let handler = handler {
                handler()
            }
        }
    }

    open subscript (index: Int) -> Item {
        return albumList[index] as Item
    }

    // MARK: - CollectionType

    open var startIndex: Int {
        return albumList.startIndex
    }

    open var endIndex: Int {
        return albumList.endIndex
    }

}


extension Notification.Name {

    static let lavenderImagePickerPickAsset: Notification.Name = Notification.Name(rawValue: "com.xiaoxiangyeyu.hn.lavender.image.picker.pick.asset")
    static let lavenderImagePickerDropAsset: Notification.Name = Notification.Name(rawValue: "com.xiaoxiangyeyu.hn.lavender.image.picker.drop.asset")
}

struct NotificationInfo {
    struct Asset {
        struct PhotoKit {
            static let didPick = Notification.Name("jp.co.nohana.NotificationName.Asset.PhotoKit.didPick")
            static let didPickUserInfoKeyAsset = "asset"
            static let didPickUserInfoKeyPickedAssetsCount = "pickedAssetsCount"
            static let didDrop = Notification.Name("jp.co.nohana.NotificationName.Asset.PhotoKit.didDrop")
            static let didDropUserInfoKeyAsset = "asset"
            static let didDropUserInfoKeyPickedAssetsCount = "pickedAssetsCount"
        }
    }
}
