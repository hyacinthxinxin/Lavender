//
//  AutoLayoutVLFViewController.swift
//  Lavender_Example
//
//  Created by 范新 on 2018/6/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Lavender

class LVEAutoLayoutVLFViewController: UIViewController {

    private enum Metrics {
        static let padding: CGFloat = 15.0
        static let iconImageViewWidth: CGFloat = 30.0
    }

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var appNameLabel: UILabel!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var appImageView: UIImageView!
    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var pageControl: UIPageControl!

    private var allConstraints: [NSLayoutConstraint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AutoLayout VLF"
        let v = UIImage.image(with: UIColor.red, size: CGSize(width: 100, height: 200))
        let iv = UIImageView(image: v)
        iv.frame = CGRect(x: 100, y: 100, width: 100, height: 200)
        view.addSubview(iv)
        /*
        let metrics = [
            "horizontalPadding": Metrics.padding,
            "iconImageViewWidth": Metrics.iconImageViewWidth]

        let views: [String: Any] = [
            "iconImageView": iconImageView,
            "appNameLabel": appNameLabel,
            "skipButton": skipButton,
            "appImageView": appImageView,
            "welcomeLabel": welcomeLabel,
            "summaryLabel": summaryLabel,
            "pageControl": pageControl]
        var allConstraints: [NSLayoutConstraint] = []

        let iconVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[iconImageView(30)]",
            metrics: nil,
            views: views)
        allConstraints += iconVerticalConstraints

        let topRowHorizontalFormat = """
H:|-horizontalPadding-[iconImageView(iconImageViewWidth)]-[appNameLabel]-[skipButton]-horizontalPadding-|
"""
        let topRowHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: topRowHorizontalFormat,
            options: [.alignAllCenterY],
            metrics: metrics,
            views: views)
        allConstraints += topRowHorizontalConstraints

        let summaryHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-horizontalPadding-[summaryLabel]-horizontalPadding-|",
            metrics: metrics,
            views: views)
        allConstraints += summaryHorizontalConstraints

        let iconToImageVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[iconImageView]-10-[appImageView]",
            metrics: nil,
            views: views)
        allConstraints += iconToImageVerticalConstraints

        let imageToWelcomeVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[appImageView]-10-[welcomeLabel]",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views)
        allConstraints += imageToWelcomeVerticalConstraints

        let summaryLabelVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[welcomeLabel]-4-[summaryLabel]",
            options: [.alignAllLeading, .alignAllTrailing],
            metrics: nil,
            views: views)
        allConstraints += summaryLabelVerticalConstraints

        let summaryToPageVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[summaryLabel]-15-[pageControl(9)]-15-|",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views)
        allConstraints += summaryToPageVerticalConstraints

        NSLayoutConstraint.activate(allConstraints)
 */
    }

    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        print(view.directionalLayoutMargins)
    }

    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        if !allConstraints.isEmpty {
            NSLayoutConstraint.deactivate(allConstraints)
            allConstraints.removeAll()
        }
//        print(view.layoutMargins)
        let newInsets = view.safeAreaInsets
//        print(newInsets)
        let leftMargin = newInsets.left > 0 ? newInsets.left : Metrics.padding
        let rightMargin = newInsets.right > 0 ? newInsets.right : Metrics.padding
        let topMargin = newInsets.top > 0 ? newInsets.top : Metrics.padding
        let bottomMargin = newInsets.bottom > 0 ? newInsets.bottom : Metrics.padding
        let metrics = [
            "horizontalPadding": Metrics.padding,
            "iconImageViewWidth": Metrics.iconImageViewWidth,
            "topMargin": topMargin,
            "bottomMargin": bottomMargin,
            "leftMargin": leftMargin,
            "rightMargin": rightMargin]
        let views: [String: Any] = [
            "iconImageView": iconImageView,
            "appNameLabel": appNameLabel,
            "skipButton": skipButton,
            "appImageView": appImageView,
            "welcomeLabel": welcomeLabel,
            "summaryLabel": summaryLabel,
            "pageControl": pageControl]
        let iconVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-topMargin-[iconImageView(30)]",
            metrics: metrics,
            views: views)
        allConstraints += iconVerticalConstraints

        let topRowHorizontalFormat = """
  H:|-leftMargin-[iconImageView(iconImageViewWidth)]-[appNameLabel]-[skipButton]-rightMargin-|
  """
        let topRowHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: topRowHorizontalFormat,
            options: [.alignAllCenterY],
            metrics: metrics,
            views: views)
        allConstraints += topRowHorizontalConstraints

        let summaryHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-horizontalPadding-[summaryLabel]-horizontalPadding-|",
            metrics: metrics,
            views: views)
        allConstraints += summaryHorizontalConstraints

        let iconToImageVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[iconImageView]-10-[appImageView]",
            metrics: nil,
            views: views)
        allConstraints += iconToImageVerticalConstraints

        let imageToWelcomeVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[appImageView]-10-[welcomeLabel]",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views)
        allConstraints += imageToWelcomeVerticalConstraints

        let summaryLabelVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[welcomeLabel]-4-[summaryLabel]",
            options: [.alignAllLeading, .alignAllTrailing],
            metrics: nil,
            views: views)
        allConstraints += summaryLabelVerticalConstraints

        let summaryToPageVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[summaryLabel]-15-[pageControl(9)]-bottomMargin-|",
            options: [.alignAllCenterX],
            metrics: metrics,
            views: views)
        allConstraints += summaryToPageVerticalConstraints
        NSLayoutConstraint.activate(allConstraints)
    }

}

extension LVEAutoLayoutVLFViewController: LavenderNavigationTransitionCenterDataSource {

    func navigationBarStyle() -> UIBarStyle {
        return .black
    }

    func navigationBackgroundColor() -> UIColor {
        return UIColor.red
    }

    func navigationBarTintColor() -> UIColor {
        return UIColor.white
    }

}
