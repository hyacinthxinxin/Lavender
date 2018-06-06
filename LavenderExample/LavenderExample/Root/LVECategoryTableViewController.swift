//
//  LVECategoryTableViewController.swift
//  LavenderExample
//
//  Created by 范新 on 2018/6/4.
//  Copyright © 2018年 xiaoxiangyeyu. All rights reserved.
//

import UIKit
import Lavender

//public protocol EnumCollection: Hashable {
//    static func cases() -> AnySequence<Self>
//    static var allValues: [Self] { get }
//}
//
//public extension EnumCollection {
//
//    public static func cases() -> AnySequence<Self> {
//
//        return AnySequence { () -> AnyIterator<Self> in
//            var raw = 0
//            return AnyIterator {
//                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
//                guard current.hashValue == raw else {
//                    return nil
//                }
//                raw += 1
//                return current
//            }
//        }
//
//    }
//
//    public static var allValues: [Self] {
//        return Array(self.cases())
//    }
//
//}

enum LVECategoryType {

    case authLayoutAnchor(title: String)// = "Auth Layout Anchor"
    case authLayoutVLF(title: String)// = "Auth Layout VFL"
    case countrySelect(title: String, localeInfo: LavenderLocaleInfo?)//= "Country Select"
    case uploadImage(title: String)
}

class LVECategoryTableViewController: UITableViewController {

    let categories: [LVECategoryType] = [
        .authLayoutAnchor(title: "Auth Layout Anchor"),
        .authLayoutVLF(title: "Auth Layout VFL"),
        .countrySelect(title: "Country Select", localeInfo: nil),
        .uploadImage(title: "Upload Image")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: nil, action: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LVECategoryCell", for: indexPath)
        switch categories[indexPath.row] {
        case let .authLayoutAnchor(title):
            cell.textLabel?.text = title
        case let .authLayoutVLF(title):
            cell.textLabel?.text = title
        case let .countrySelect(title, localeInfo):
            cell.textLabel?.text = title
            LVU.logging(localeInfo)
        case let .uploadImage(title):
            cell.textLabel?.text = title
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var viewController: UIViewController?
        let category = categories[indexPath.row]
        switch category {
        case .authLayoutAnchor:
            viewController = LVEAutoLayoutAnchorViewController(nibName: nil, bundle: nil)
        case .authLayoutVLF:
            viewController = UIStoryboard(name: "LVEAutoLayout", bundle: nil).instantiateInitialViewController() as? LVEAutoLayoutVLFViewController
        case .countrySelect:
            viewController = LavenderLocalePickerViewController(nibName: nil, bundle: nil)
        case .uploadImage:
            viewController = LavenderUploadImageViewController(nibName: nil, bundle: nil)
        }
        guard let _viewController = viewController else {
            return
        }
        _viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(_viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
