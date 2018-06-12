//
//  LavenderUploadImageViewController.swift
//  LavenderExample
//
//  Created by 范新 on 2018/6/6.
//  Copyright © 2018年 xiaoxiangyeyu. All rights reserved.
//

import UIKit
import Lavender
import MobileCoreServices
import Photos

class LavenderUploadImageViewController: UIViewController {

    var pickedAssetList: LavenderImagePickerPickedAssetList = LavenderImagePickerPickedAssetList()  {
        willSet {
            images = newValue.resolveAssets()
        }
    }

    var images: [UIImage]? {
        didSet {
            if let images = self.images {
                for image in images {
                    LVU.logging(image)
                }
            }
        }
    }

    var assets: [PHAsset] = [PHAsset]() {
        didSet {
            for asset in assets {
                LVU.logging(asset.mediaType)
                LVU.logging(asset.sourceType)

            }
        }
    }

    lazy var selectSinglePhotoButton: UIButton = { [unowned self] in
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("系统单选照片", for: .normal)
        $0.setTitleColor(UIColor.orange, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        $0.contentHorizontalAlignment = .center
        $0.backgroundColor = UIColor.cyan
        $0.addTarget(self, action: #selector(selectSinglePhoto(_:)), for: .touchUpInside)
        return $0
        }(UIButton(type: .custom))

    lazy var selectMultiplePhotosButton: UIButton = { [unowned self] in
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("自定义多选照片", for: .normal)
        $0.setTitleColor(UIColor.orange, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        $0.contentHorizontalAlignment = .center
        $0.backgroundColor = UIColor.cyan
        $0.addTarget(self, action: #selector(selectMultiplePhotos(_:)), for: .touchUpInside)
        return $0
        }(UIButton(type: .custom))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(selectSinglePhotoButton)
        view.addSubview(selectMultiplePhotosButton)
        NSLayoutConstraint.activate([
            selectSinglePhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            selectSinglePhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            selectSinglePhotoButton.heightAnchor.constraint(equalToConstant: 52),
            ])
        if #available(iOS 11.0, *) {
           selectSinglePhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        } else {
            selectSinglePhotoButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8).isActive = true
        }
        NSLayoutConstraint.activate([
            selectMultiplePhotosButton.leadingAnchor.constraint(equalTo: selectSinglePhotoButton.leadingAnchor),
            selectMultiplePhotosButton.trailingAnchor.constraint(equalTo: selectSinglePhotoButton.trailingAnchor),
            selectMultiplePhotosButton.heightAnchor.constraint(equalToConstant: 52),
            selectMultiplePhotosButton.topAnchor.constraint(equalTo: selectSinglePhotoButton.bottomAnchor, constant: 8)
            ])
    }

    @objc fileprivate func selectMultiplePhotos(_ sender: UIButton) {
        let imagePicker = LavenderImagePickerController()
        pickedAssetList.controller = imagePicker
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        imagePicker.pickedAssetList = self.pickedAssetList
        present(imagePicker, animated: true, completion: nil)
    }

    @objc fileprivate func selectSinglePhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
//        picker.sourceType = .camera
        picker.sourceType = .savedPhotosAlbum
//        picker.allowsEditing = true
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.savedPhotosAlbum)!
//        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

}

extension LavenderUploadImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, LavenderImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            print(image.size)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // MARK: - LavenderImagePickerControllerDelegate

    func imagePickerControllerDidCancel(_ picker: LavenderImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: LavenderImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let images = info[LavenderImagePickerControllerInfoKey.pickedImages] as? [UIImage] {
            for image in images {
                LVU.logging(image)
            }
        }
        if let pickedAssetList = info[LavenderImagePickerControllerInfoKey.pickedAssetList] as? LavenderImagePickerPickedAssetList {
            self.pickedAssetList = pickedAssetList
        }
    }

}

