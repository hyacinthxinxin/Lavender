//
//  LVETabBarController.swift
//  LavenderExample
//
//  Created by 范新 on 2018/6/4.
//  Copyright © 2018年 xiaoxiangyeyu. All rights reserved.
//

import UIKit
import Lavender

class LVETabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if let mainLoadingViewController = UIStoryboard(name: "LVEMainLoading", bundle: nil).instantiateInitialViewController() as? LVEMainLoadingViewController {
            setViewControllers([mainLoadingViewController], animated: true)
            LVU.delay(seconds: 1.2) { [weak self] in
                guard let `self` = self else { return }
                mainLoadingViewController.indicatorView.stopAnimating()
                self.setupMainTabBarViewControllers()
            }
        }
    }

    fileprivate func setupMainTabBarViewControllers() {
        guard let firstNavigationController = UIStoryboard(name: "LVECategory", bundle: nil).instantiateInitialViewController() as? UINavigationController else { return }
        setViewControllers([firstNavigationController], animated: true)
    }

}
