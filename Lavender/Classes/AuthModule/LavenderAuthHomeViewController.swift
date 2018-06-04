//
//  LavenderAuthHomeViewController.swift
//  Lavender
//
//  Created by 范新 on 2018/6/2.
//

import UIKit

open class LavenderAuthHomeViewController: LavenderAuthBaseViewController {

    lazy var loginButton: UIButton = { [unowned self] in
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("登录", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        $0.setBackgroundImage(UIImage.image(with: UIColor.cyan), for: .normal)
        return $0
        }(UIButton(type: .custom))

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.brown
        var layoutGuide: UILayoutGuide!
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            layoutGuide = view.layoutMarginsGuide
        }

        let myView = UIView()
        myView.backgroundColor = UIColor.cyan
        myView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myView)
        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.size.height + 64 + 40),
            myView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 20),
            myView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 0),
            myView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -20)
            ])
//        myView.topAnchor.constraint(equalTo: view.topAnchor, constant: 104).isActive = true
//        myView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 20).isActive = true
//        myView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -64).isActive = true
//        myView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -20).isActive = true
//        myView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.addSubview(loginButton)
        let views = ["loginButton": loginButton]
        let formatString = "|-[loginButton]-|"
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: formatString, options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: views)
        logger(constraints)
        NSLayoutConstraint.activate(constraints)
    }

    @objc func clickLoginButton(_ sender: UIButton) {

    }

}
