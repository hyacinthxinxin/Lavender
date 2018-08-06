//
//  LVEWebViewController.swift
//  LavenderExample
//
//  Created by 范新 on 2018/7/4.
//  Copyright © 2018年 xiaoxiangyeyu. All rights reserved.
//

import UIKit
import WebKit
import Lavender

class LVEWebViewController: UIViewController {

    var url: URL?

    var htmlString: String?

    fileprivate var webView: WKWebView!

    fileprivate let progressView = UIProgressView(progressViewStyle: .default)

    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        //        webView.navigationDelegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "web"
        setupUI()
        setupProgressView()
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if webView.isLoading {
            webView.stopLoading()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.configuration.userContentController.removeAllUserScripts()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "javaScriptCallToSwift")
    }

    fileprivate func setupProgressView() {
        view.addSubview(progressView)
        progressView.progressTintColor = .orange
        progressView.trackTintColor = .white
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.alpha = 0.0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: webView.topAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0)
            ])
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? WKWebView === webView {
            if keyPath == #keyPath(WKWebView.estimatedProgress)  {
                progressView.progress = Float(webView.estimatedProgress)
            } else if keyPath == #keyPath(WKWebView.title) {
                self.title = webView.title
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        view.addSubview(webView)
        webView.frame = CGRect(x: 0, y: 0, width: LVC.screenWidth, height: LVC.screenHeight - 64)
        if self.htmlString != nil {
            let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
            let userScript = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
            webView.configuration.userContentController.addUserScript(userScript)
        }
        let js = "localStorage.setItem('platform','3');" + "localStorage.setItem('lz_sso_token','cb78325220d94909889e27fc093df18c');"
        let userScript = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(userScript)
//        loadRemote()
    }

    fileprivate func loadRemote() {
        if let url = URL(string: "https://lvq.bendixing.net/setting?barId=194&platform=iOS") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
//        if let url = self.url {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        } else {
//            if let htmlString = self.htmlString {
//                webView.loadHTMLString(htmlString, baseURL: URL(string: ApiConfig.baseURLString))
//            }
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadRemote()
    }

}

extension LVEWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        progressView.alpha = 0.0
        UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 1.0
        })
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        hideProgressView()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        hideProgressView()
    }

    fileprivate func hideProgressView() {
        progressView.alpha = 1.0
        UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0.0
        })
    }
}

extension LVEWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
