//
//  LVENavigationController.swift
//  LavenderExample
//
//  Created by 范新 on 2018/6/4.
//  Copyright © 2018年 xiaoxiangyeyu. All rights reserved.
//

import UIKit
import Lavender

class LVENavigationController: UINavigationController {

    var transitionCenter: LavenderNavigationTransitionCenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        transitionCenter = LavenderNavigationTransitionCenter(dataSource: self)
    }

}

extension LVENavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        transitionCenter.navigationController(navigationController, willShow: viewController, animated: animated)
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        transitionCenter.navigationController(navigationController, didShow: viewController, animated: animated)
    }

}

extension LVENavigationController: LavenderNavigationTransitionCenterDataSource {

    func navigationBarStyle() -> UIBarStyle {
        return .default
    }

    func navigationBackgroundColor() -> UIColor {
        return UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1)
    }

    func navigationBarTintColor() -> UIColor {
        return UIColor.brown
    }

}
