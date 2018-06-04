//
//  LavenderAuthUserViewController.swift
//  Lavender
//
//  Created by 范新 on 2018/6/2.
//

import UIKit

open class LavenderAuthUserViewController: LavenderAuthBaseViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.brown
        if #available(iOS 11.0, *) {
//            additionalSafeAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            // Fallback on earlier versions
        }
//        setupMyView()
//        setupViewWithVFL()
    }

    fileprivate func setupMyView() {
        let myView = UIView()
        myView.backgroundColor = UIColor.cyan
        myView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myView)
        if #available(iOS 11, *) {
            // SystemSpacing {8, 8, 8, 8} is when Use constraintEqualToSystemSpacingBelow OR constraintEqualToSystemSpacingAfter
            NSLayoutConstraint.activate([
                myView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                myView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
                myView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                myView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
                ])
        } else {
            NSLayoutConstraint.activate([
                myView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0),
                myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                myView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0),
                myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
                ])
        }
        /*
        let views = ["myView": myView]
        let formatString = "|-[myView]-|"
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: formatString, options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
 */
    }

    /// Guaid https://www.raywenderlich.com/174078/auto-layout-visual-format-language-tutorial-2
    fileprivate func setupViewWithVFL() {

    }

}
