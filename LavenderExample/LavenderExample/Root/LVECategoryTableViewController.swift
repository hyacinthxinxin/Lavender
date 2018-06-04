//
//  LVECategoryTableViewController.swift
//  LavenderExample
//
//  Created by 范新 on 2018/6/4.
//  Copyright © 2018年 xiaoxiangyeyu. All rights reserved.
//

import UIKit

enum LVECategoryType {
    case authLayout
}

protocol LVECategoryCompatible {
    var type: LVECategoryType { get }
}

struct LVECategory: LVECategoryCompatible {
    var title: String?
    var type: LVECategoryType = .authLayout

    init(title: String) {
        self.title = title
    }
}

class LVECategoryTableViewController: UITableViewController {

    let categories = [
        LVECategory(title: "AutoLayout")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LVECategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var viewController: UIViewController?
        let category = categories[indexPath.row]
        switch category.type {
        case .authLayout:
            viewController = UIStoryboard(name: "LVEAutoLayout", bundle: nil).instantiateInitialViewController() as? LVEAutoLayoutVLFViewController
        }
        guard let _viewController = viewController else {
            return
        }
        _viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(_viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
