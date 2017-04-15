//
//  WebViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 11/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView?
    
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
            challenge.sender?.use(credential, for: challenge)
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
            
            if let theWebView = webView {
                /* Load a web page into our web view */
                let urlRequest = self.request
                theWebView.load(urlRequest)
                theWebView.navigationDelegate = self
                view.addSubview(theWebView)
            }
        } // else for connection available
        
        // Hide the navigation bar for this view
        self.navigationController?.isNavigationBarHidden = true
    }
}
