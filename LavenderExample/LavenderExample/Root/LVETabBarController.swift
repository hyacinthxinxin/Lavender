//
//  LVETabBarController.swift
//  LavenderExample
//
//  Created by 范新 on 2018/6/4.
//  Copyright © 2018年 xiaoxiangyeyu. All rights reserved.
//

import UIKit
import Lavender

struct Country: Codable {
    var chinaName: String
    var isni: String
    var internaCode: String
    var qtq: String
    var regent: String

    enum CodingKeys: String, CodingKey {
        case chinaName = "ChinaName"
        case isni = "ISNI"
        case internaCode = "InternaCode"
        case qtq = "QTQ"
        case regent = "REGENT"
    }

}

class LVETabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let str = "aBcDec"
//        print(str.localizedStandardRange(of: "ab"))
//        print(str.capitalized)
//        print(str.uppercased())
//        print(str.lowercased())

        view.backgroundColor = UIColor.white
//        self.setupMainTabBarViewControllers()

//        if let url = Bundle.main.url(forResource: "CountryCode", withExtension: "plist") {
//            do {
//                let data = try Data(contentsOf: url)
//                let countries = try PropertyListDecoder().decode([Country].self, from: data)
//                LVU.logging(countries)
//            } catch {
//
//            }
//
//        }

        if let mainLoadingViewController = UIStoryboard(name: "LVEMainLoading", bundle: nil).instantiateInitialViewController() as? LVEMainLoadingViewController {
            setViewControllers([mainLoadingViewController], animated: true)
            LVU.delay(seconds: 1.2) { [weak self] in
                guard let `self` = self else { return }
                mainLoadingViewController.indicatorView.stopAnimating()
                self.setupMainTabBarViewControllers()
            }
        }

        if let url = URL(string: "https://5b67f356629e280014570c49.mockapi.io/users/1") {
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest) { (data, reseponse, error) in
                if let jsonData = data {
                    print("success")
                    do {
                        let x = try JSONSerialization.jsonObject(with: jsonData, options: [])
                        print(x)
                        let decoder = JSONDecoder()
                        let RFC3339DateFormatter = DateFormatter()
//                        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
//                        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//                        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                        decoder.dateDecodingStrategy = .formatted(RFC3339DateFormatter)
                        let users = try decoder.decode(User.self, from: jsonData)
                        print(users)
                    } catch {

                    }
                }
            }.resume()
        }

        /*
        if let url = URL(string: "https://5b67f356629e280014570c49.mockapi.io/posts") {
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest) { (data, reseponse, error) in
                if let jsonData = data {
                    do {
                        let posts = try JSONDecoder().decode([Post].self, from: jsonData)

                        print(posts)
                    } catch {

                    }
                }
                }.resume()
        }
*/
    }

    fileprivate func setupMainTabBarViewControllers() {
        guard let categoryTableViewController = UIStoryboard(name: "LVECategory", bundle: nil).instantiateInitialViewController() as? LVECategoryTableViewController else { return }
        let simpleViewController = LVESimpleViewController(nibName: nil, bundle: nil)
        let webViewController = LVEWebViewController(nibName: nil, bundle: nil)
        setViewControllers([LVENavigationController(rootViewController: categoryTableViewController), simpleViewController, webViewController], animated: true)
        selectedIndex = 1
    }

}

struct User: Codable {
    var id: String
    var createdAt: Date
    var name: String
    var avatar: String
}

struct Post: Codable {

    var id: String
    var createdAt: String
    var title: String
    var content: String
    var userId: Int

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case title
        case content
        case userId = "uid"
    }

}
