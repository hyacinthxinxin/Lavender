//
//  LavenderImagePickerThumbnailToolbar.swift
//  Lavender
//
//  Created by 范新 on 2018/6/8.
//

import UIKit

class LavenderImagePickerThumbnailToolbar: UIView {

    weak var controller :LavenderImagePickerController?

    lazy var bgView: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()

    lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("完成", for: .normal)
        button.backgroundColor = UIColor.green
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(bgView)
        bgView.delegate = self
        doneButton.addTarget(self, action: #selector(didTouchDone(_:)), for: .touchUpInside)
        addSubview(doneButton)
//        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[bgView]-0-|", metrics: nil, views: ["bgView": bgView]))
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            doneButton.widthAnchor.constraint(equalToConstant: 100)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc fileprivate func didTouchDone(_ sender: UIButton) {
        guard let controller = self.controller else { return }
        let images = controller.pickedAssetList.resolveAssets()
        controller.imagePickerDelegate?.imagePickerController(controller, didFinishPickingMediaWithInfo: [
            LavenderImagePickerControllerInfoKey.pickedAssetList: controller.pickedAssetList,
            LavenderImagePickerControllerInfoKey.pickedImages: images])
    }

}

extension LavenderImagePickerThumbnailToolbar: UIToolbarDelegate {

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .bottom
    }
    
}
