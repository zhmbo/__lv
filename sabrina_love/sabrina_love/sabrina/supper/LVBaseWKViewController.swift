//
//  LVBaseWKViewController.swift
//  sabrina_love
//
//  Created by Jumbo on 2020/1/17.
//  Copyright © 2020 Jumbo. All rights reserved.
//

import UIKit
import WebKit

class LVBaseWKViewController: UIViewController,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler {
    
    var wkRouter: String? {
        didSet {
            guard lvInitModel.lvSuperScene && lvInitModel.lv_add_idfa == 1 else {
                return
            }
            if (wkRouter ?? "").contains("?") {
                wkRouter = (wkRouter ?? "") + "&idfa=" + lvIdfa
            }else {
                wkRouter = (wkRouter ?? "") + "?idfa=" + lvIdfa
            }
        }
    }
    
    // scheme
    let lvNavigationScheme: String = "sabrina"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if #available(iOS 13.0, *) {
            self.view.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(self.lvWebView)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedRotation), name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
        
        self.receivedRotation()
    }
    
    @objc func receivedRotation() {
        
        let margin: CGFloat  = lvInitModel.lv_iphone_x == 1 && isFullScreen ? 34 : 0
        
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            self.lvWebView.frame = CGRect.init(x: 0, y: margin, width: lvScreenWidth(), height: lvScreenHeight()-margin)
        case .portraitUpsideDown:
            self.lvWebView.frame = CGRect.init(x: 0, y: margin, width: lvScreenWidth(), height: lvScreenHeight()-margin)
        case .landscapeLeft:
            self.lvWebView.frame = CGRect.init(x: 0, y: 0, width: lvScreenWidth()-margin, height: lvScreenHeight())
        case .landscapeRight:
            self.lvWebView.frame = CGRect.init(x: margin, y: 0, width: lvScreenWidth()-margin, height: lvScreenHeight())
        case .unknown:
            self.lvWebView.frame = CGRect.init(x: 0, y: 0, width: lvScreenWidth(), height: lvScreenHeight())
        @unknown default:
            self.lvWebView.frame = CGRect.init(x: 0, y: 0, width: lvScreenWidth(), height: lvScreenHeight())
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 横竖屏管理
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        switch lvInitModel.lv_orientation {
        case 1:
        return .portrait
        case 2:
        return .landscape
        case 3:
        return .all
        default:
        return .portrait
        }
    }

    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        // 在JS端调用alert函数时，会触发此代理方法。
        // JS端调用alert时所传的数据可以通过message拿到
        // 在原生得到结果后，需要回调JS，是通过completionHandler回调
        let alertView = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "确定", style: .destructive) { (action:UIAlertAction) in
            //确定
            completionHandler()
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        // JS端调用confirm函数时，会触发此方法
        // 通过message可以拿到JS端所传的数据
        // 在iOS端显示原生alert得到YES/NO后
        // 通过completionHandler回调给JS端
        let alertView = UIAlertController.init(title: "提示", message:message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action:UIAlertAction) in
            //取消
            completionHandler(false)
        }
        alertView.addAction(cancelAction)
        let okAction = UIAlertAction.init(title: "确定", style: .default) { (action:UIAlertAction) in
            //确定
            completionHandler(true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        // JS端调用prompt函数时，会触发此方法
        // 要求输入一段文本
        // 在原生输入得到文本内容后，通过completionHandler回调给JS
        let alertTextField = UIAlertController.init(title: "请输入", message: "JS调用输入框", preferredStyle: .alert)
        alertTextField.addTextField { (textField:UITextField) in
            //设置textField相关属性
            textField.textColor = UIColor.red
        }
        let okAction = UIAlertAction.init(title: "确定", style: .destructive) { (action:UIAlertAction) in
            //确定
            completionHandler(alertTextField.textFields?.last?.text)
        }
        alertTextField.addAction(okAction)
        self.present(alertTextField, animated: true, completion: nil)
    }

    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //页面开始加载，可在这里给用户loading提示
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //内容开始到达时
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //页面加载完成时
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //页面加载出错，可在这里给用户错误提示
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // 收到服务器重定向请求
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // 在请求开始加载之前调用，决定是否跳转
        let url: URL = navigationAction.request.url!
        let scheme: String = url.scheme ?? ""
        let host: String = url.host ?? ""
        let query: String = url.query ?? ""
        
        print("【url】: \(url)")
        print("【scheme】: \(scheme)")
        print("【host】: \(host)")
        print("【query】: \(query)")
        
        if scheme == lvNavigationScheme {
            
            if "removeCache" == host {
                self.removeCache()
            }
            if "openUrl" == host && "" != query {
                UIApplication.shared.openURL(URL(string: query)!)
            }
            
            decisionHandler(.cancel)
        }else {

            decisionHandler(.allow)
        }
        
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // 在收到响应开始加载后，决定是否跳转
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    //MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // h5给端传值的内容，可在这里实现h5与原生的交互时间
    }
    
    // MARK: - WB FUNC
    func removeCache() {
        
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        
        // Date from
        let modifiedSince = Date(timeIntervalSince1970: 0)
        
        // Execute
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: modifiedSince) {
            print("清除缓存完毕")
        }
    }

    // MARK: - lazy
    lazy var lvWebView: WKWebView = {
        let myWebView = WKWebView.init(frame: self.view.frame, configuration: self.wkConfiguration)
        let web_url = URL.init(string: self.wkRouter ?? "")
        myWebView.load(URLRequest.init(url: web_url!))
        myWebView.navigationDelegate = self
        myWebView.uiDelegate = self
        myWebView.scrollView.bounces = false
        if #available(iOS 11.0, *) {
            myWebView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return myWebView
    }()

    lazy var wkConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration.init()
        configuration.selectionGranularity = .dynamic
        configuration.preferences = self.wkPreferences
        configuration.userContentController = self.wkUserContentController
        return configuration
    }()
    
    lazy var wkPreferences: WKPreferences = {
        let preferences = WKPreferences.init()
        preferences.javaScriptCanOpenWindowsAutomatically = false
        preferences.javaScriptEnabled = true
        preferences.minimumFontSize = 18
        return preferences
    }()

    lazy var wkUserContentController: WKUserContentController = {
        let userConetentController = WKUserContentController.init()
//        userConetentController.add(self, name: lvScriptMessageHandler)
        return userConetentController
    }()
}
