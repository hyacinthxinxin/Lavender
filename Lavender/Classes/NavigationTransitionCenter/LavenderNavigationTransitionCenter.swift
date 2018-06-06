//
//  LavenderNavigationTransitionCenter.swift
//  Lavender
//
//  Created by 范新 on 2018/6/4.
//

import UIKit

// MARK: - 必要的时候刷新状态栏颜色和透明度
extension Lavender where Base: UIViewController {

    public func refreshNavigationBarStyle() {
        if let dataSource = base as? LavenderNavigationTransitionCenterDataSource {
            base.fx_navigationBar()?.lv_apply(LavenderNavigationTransitionConfiguration(dataSource: dataSource))
        }
    }

}

/// 状态栏控制协议
public protocol LavenderNavigationTransitionCenterDataSource {
    func navigationBarStyle() -> UIBarStyle
    func navigationBackgroundColor() -> UIColor
    func navigationBarTintColor() -> UIColor
}

/// 状态栏控制中心
public class LavenderNavigationTransitionCenter: NSObject {

    fileprivate lazy var fromViewControllerFakeBar: UIToolbar = { [unowned self] in
        let toolbar = UIToolbar(frame: CGRect.zero)
        toolbar.delegate = self
        return toolbar
        }()

    fileprivate lazy var toViewControllerFakeBar: UIToolbar = { [unowned self] in
        let toolbar = UIToolbar(frame: CGRect.zero)
        toolbar.delegate = self
        return toolbar
        }()

    fileprivate var defaultConfiguration: LavenderNavigationTransitionConfiguration?

    fileprivate var isTransitioning: Bool = false

    public convenience init(dataSource: LavenderNavigationTransitionCenterDataSource) {
        self.init()
        defaultConfiguration = LavenderNavigationTransitionConfiguration(dataSource: dataSource)
    }

    fileprivate func removeFakeBars() {
        fromViewControllerFakeBar.removeFromSuperview()
        toViewControllerFakeBar.removeFromSuperview()
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let defaultConfiguration = self.defaultConfiguration else {
            return
        }
        let currentConfiguration = navigationController.navigationBar.currentNavigationTransitionConfiguration ?? defaultConfiguration
        var showConfiguration = defaultConfiguration
        if let dataSource = viewController as? LavenderNavigationTransitionCenterDataSource {
            showConfiguration = LavenderNavigationTransitionConfiguration(dataSource: dataSource)
        }
        var transparentConfiguration: LavenderNavigationTransitionConfiguration?
        if currentConfiguration != showConfiguration {
            transparentConfiguration = LavenderNavigationTransitionConfiguration(barStyle: showConfiguration.barStyle, tintColor: showConfiguration.tintColor, backgroundColor: UIColor.clear)
        }
        navigationController.navigationBar.lv_apply(transparentConfiguration ?? showConfiguration)
        navigationController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            if currentConfiguration != showConfiguration {
                UIView.setAnimationsEnabled(false)
                if let fromViewController = context.viewController(forKey: .from),
                    let fakeBarFrame = fromViewController.fx_fakeBarFrame(for: navigationController.navigationBar) {
                    self.fromViewControllerFakeBar.lv_apply(currentConfiguration)
                    self.fromViewControllerFakeBar.frame = fakeBarFrame
                    fromViewController.view.addSubview(self.fromViewControllerFakeBar)
                }
                if let toViewController = context.viewController(forKey: UITransitionContextViewControllerKey.to),
                    let fakeBarFrame = toViewController.fx_fakeBarFrame(for: navigationController.navigationBar) {
                    self.toViewControllerFakeBar.lv_apply(showConfiguration)
                    self.toViewControllerFakeBar.frame = fakeBarFrame
                    toViewController.view.addSubview(self.toViewControllerFakeBar)
                }
                UIView.setAnimationsEnabled(true)
            }
        }, completion: { (context) in
            if context.isCancelled {
                self.removeFakeBars()
                navigationController.navigationBar.lv_apply(currentConfiguration)
            }
            self.isTransitioning = false
        })
        if #available(iOS 10, *) {
            navigationController.transitionCoordinator?.notifyWhenInteractionChanges({ (context) in
                if context.isCancelled {
                    navigationController.navigationBar.lv_apply(currentConfiguration)
                }
            })
        } else {
            navigationController.transitionCoordinator?.notifyWhenInteractionEnds({ (context) in
                if context.isCancelled {
                    navigationController.navigationBar.lv_apply(currentConfiguration)
                }
            })
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        removeFakeBars()
        guard let defaultConfiguration = self.defaultConfiguration else {
            return
        }
        var showConfiguration = defaultConfiguration
        if let dataSource = viewController as? LavenderNavigationTransitionCenterDataSource {
            showConfiguration = LavenderNavigationTransitionConfiguration(dataSource: dataSource)
        }
        navigationController.navigationBar.lv_apply(showConfiguration)
        isTransitioning = false
    }

}

// MARK: - Fake Bar 顶部
extension LavenderNavigationTransitionCenter: UIToolbarDelegate {

    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }

}

/// 配置
struct LavenderNavigationTransitionConfiguration {

    var barStyle: UIBarStyle = .default
    var tintColor: UIColor = UIColor.blue
    var backgroundColor: UIColor = UIColor.white

    init(barStyle: UIBarStyle, tintColor: UIColor, backgroundColor: UIColor) {
        self.barStyle = barStyle
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }

    init(dataSource: LavenderNavigationTransitionCenterDataSource) {
        self.init(barStyle: dataSource.navigationBarStyle(), tintColor: dataSource.navigationBarTintColor(), backgroundColor: dataSource.navigationBackgroundColor())
    }

}

extension LavenderNavigationTransitionConfiguration: Equatable {

    static func == (lhs: LavenderNavigationTransitionConfiguration, rhs: LavenderNavigationTransitionConfiguration) -> Bool {
        return lhs.barStyle == rhs.barStyle && lhs.tintColor == rhs.tintColor && lhs.backgroundColor == rhs.backgroundColor
    }

}

fileprivate var lavenderCurrentNavigationBarConfiguration = "lavenderCurrentNavigationBarConfiguration"

extension UINavigationBar {

    var currentNavigationTransitionConfiguration: LavenderNavigationTransitionConfiguration? {
        get {
            return objc_getAssociatedObject(self, &lavenderCurrentNavigationBarConfiguration) as? LavenderNavigationTransitionConfiguration
        }
        set {
            objc_setAssociatedObject(self, &lavenderCurrentNavigationBarConfiguration, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func lv_apply(_ configuration: LavenderNavigationTransitionConfiguration) {
        barStyle = configuration.barStyle
        isTranslucent = true
        tintColor = configuration.tintColor
        if configuration.backgroundColor == UIColor.clear {
            (value(forKey: "_backgroundView") as? UIView)?.alpha = 0
        } else {
            (value(forKey: "_backgroundView") as? UIView)?.alpha = 1
        }
        setBackgroundImage(UIImage.image(with: configuration.backgroundColor), for: .default)
        shadowImage = UIImage()
        currentNavigationTransitionConfiguration = configuration
    }

}

extension UIToolbar {

    func lv_apply(_ configuration: LavenderNavigationTransitionConfiguration) {
        barStyle = configuration.barStyle
        isTranslucent = true
        tintColor = configuration.tintColor
        setBackgroundImage(UIImage.image(with: configuration.backgroundColor), forToolbarPosition: .any, barMetrics: .default)
        setShadowImage(UIImage(), forToolbarPosition: .any)
    }

}

extension UIViewController {

    func fx_navigationBar() -> UINavigationBar? {
        if self is UINavigationController {
            return (self as? UINavigationController)?.navigationBar
        }
        return self.navigationController?.navigationBar
    }

    func fx_fakeBarFrame(for navigationBar: UINavigationBar) -> CGRect? {
        guard let backgroundView = navigationBar.value(forKey: "_backgroundView") as? UIView,
            var frame = backgroundView.superview?.convert(backgroundView.frame, to: self.view) else {
                return nil
        }
        frame.origin.x = view.bounds.origin.x
        return frame
    }

}
