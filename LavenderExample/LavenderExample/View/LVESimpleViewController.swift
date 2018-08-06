//
//  LVESimpleViewController.swift
//  LavenderExample
//
//  Created by 范新 on 2018/7/3.
//  Copyright © 2018年 xiaoxiangyeyu. All rights reserved.
//

import UIKit
import Lavender

class LVESimpleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(origin: CGPoint(x: 20, y: LVC.statusBarHeight + 20), size: CGSize(width: LVC.screenWidth - 40, height: 52))
        btn.setBackgroundImage(#imageLiteral(resourceName: "purple_button"), for: .normal)
        view.addSubview(btn)

        let btn2 = UIButton(type: .custom)
        btn2.frame = CGRect(origin: CGPoint(x: 20, y: btn.frame.maxY + 20), size: CGSize(width: LVC.screenWidth - 40, height: 52))
        btn2.setBackgroundImage(#imageLiteral(resourceName: "buttons_PNG105"), for: .normal)
        view.addSubview(btn2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
