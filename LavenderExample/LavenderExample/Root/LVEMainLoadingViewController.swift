//
//  LVEMainLoadingViewController.swift
//  LavenderExample
//
//  Created by 范新 on 2018/6/4.
//  Copyright © 2018年 xiaoxiangyeyu. All rights reserved.
//

import UIKit

class LVEMainLoadingViewController: UIViewController {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.startAnimating()
    }

}
