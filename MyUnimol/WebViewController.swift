//
//  WebViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 11/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, UIToolbarDelegate {
    
    var webView: WKWebView?
    var toolBar: UIToolbar!
    
    fileprivate var request: URLRequest {
        let baseUrl = "https://unimol.esse3.cineca.it/auth/Logon.do"
        let URL = Foundation.URL(string: baseUrl)!
        return URLRequest(url: URL)
    }
    
    fileprivate var userScript: WKUserScript {
        let source = "javascript:cookies.set()"
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        return userScript
    }
    
    /* Start the network activity indicator when the web view is loading */
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    /* Stop the network activity indicator when the loading finishes */
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                                                   decisionHandler: (@escaping (WKNavigationResponsePolicy) -> Void)){
        decisionHandler(.allow)
    }
    
    /// Perform automatic login
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.host == "unimol.esse3.cineca.it" {
            let (user, password) = CacheManager.sharedInstance.getUserCredential()
            let credential = URLCredential(user: user!, password: password!, persistence: URLCredential.Persistence.forSession)
            
            /// La successiva funzione fa crashare l'app, l'ho commentata dopo aver letto il
            /// workaround da questo link https://forums.developer.apple.com/thread/72469
            
            //challenge.sender?.use(credential, for: challenge) // <--- Crash
            
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        }
    }
    
    override func viewDidLoad() {
        
        if !Reachability.isConnectedToNetwork() {
            Utils.displayAlert(self, title: "😨 Ooopss...", message: "Forse non hai una connessione disponibile per accedere al tuo portale 😔")
            Utils.goToMainPage()
        } else {
            
            /* Create our preferences on how the web page should be loaded */
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            
            let userContentController = WKUserContentController()
            userContentController.addUserScript(self.userScript)
            
            /* Create a configuration for our preferences */
            let configuration = WKWebViewConfiguration()
            configuration.preferences = preferences
            configuration.userContentController = userContentController
            
            /* Now instantiate the web view */
            webView = WKWebView(frame: view.bounds, configuration: configuration)
            
            // make uitoolbar instance
            toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.bounds.size.height - 44, width: self.view.bounds.size.width, height: 40.0))
            
            if let theWebView = webView {
                /* Load a web page into our web view */
                let urlRequest = self.request
                theWebView.load(urlRequest)
                theWebView.navigationDelegate = self
                view.addSubview(theWebView)
            }
        } // else for connection available
        
        
        Utils.setNavigationControllerStatusBar(self, title: "", color: Utils.myUnimolBlue, style: UIBarStyle.black)

        // Creo la toolbar
        drawToolbar(toolBar: toolBar)
        
        // Setto i constraints
        setConstraints()
    }
    
    
    func setConstraints() {
        //Aggiungo i constraints con la Visual Language Format
        view.addConstraintsWithFormat(format: "H:|[v0]|", metrics: nil, views: webView!)
        view.addConstraintsWithFormat(format: "H:|[v0]|", metrics: nil, views: toolBar)
        view.addConstraintsWithFormat(format: "V:|[v0]-[v1]|", metrics: nil, views: webView!, toolBar)
    }
    
    private func drawToolbar(toolBar: UIToolbar) {
        
        // set the position of toolbar
        toolBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-20.0)
        
        // set the color of the toolbar
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = .white
        toolBar.backgroundColor = .black
        
        // make buttons
        let refreshBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "Refresh").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onClickBarButton))
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onClickBarButton))
        let forwardBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "Forward").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onClickBarButton))
        let stopBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "Stop").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onClickBarButton))
        
        
        refreshBtn.tag = 1
        backBtn.tag = 2
        forwardBtn.tag = 3
        stopBtn.tag = 4
        
        // Flexible Space
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        // Fixed Space
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 60.0
        
        // add the button on the toolbar
        toolBar.items = [backBtn, fixedSpace, forwardBtn, flexibleSpace, refreshBtn, fixedSpace, stopBtn]
        
        // add the toolbar to the webView
        //self.webView?.addSubview(toolBar)
        view.addSubview(toolBar)
    }
    
    func onClickBarButton(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            webView?.reload()
        case 2:
            webView?.goBack()
        case 3:
            webView?.goForward()
        case 4:
            webView?.stopLoading()
        default:
            print("ERROR!!")
        }
    }
}

