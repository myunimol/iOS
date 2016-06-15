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
    
    private var request: NSURLRequest {
        let baseUrl = "https://unimol.esse3.cineca.it/auth/Logon.do"
        let URL = NSURL(string: baseUrl)!
        return NSURLRequest(URL: URL)
    }
    
    private var userScript: WKUserScript {
        let source = "javascript:cookies.set()"
        let userScript = WKUserScript(source: source, injectionTime: .AtDocumentStart, forMainFrameOnly: false)
        return userScript
    }
    
    /* Start the network activity indicator when the web view is loading */
    func webView(webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    /* Stop the network activity indicator when the loading finishes */
    func webView(webView: WKWebView,
                 didFinishNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: WKWebView,
                 decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse,
                                                   decisionHandler: ((WKNavigationResponsePolicy) -> Void)){
        decisionHandler(.Allow)
    }
    
    /// Perform automatic login
    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        if challenge.protectionSpace.host == "unimol.esse3.cineca.it" {
            let (user, password) = CacheManager.sharedInstance.getUserCredential()
            let credential = NSURLCredential(user: user!, password: password!, persistence: NSURLCredentialPersistence.ForSession)
            challenge.sender?.useCredential(credential, forAuthenticationChallenge: challenge)
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
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
                theWebView.loadRequest(urlRequest)
                theWebView.navigationDelegate = self
                view.addSubview(theWebView)
            }
        } // else for connection available
        
        // Hide the navigation bar for this view
        self.navigationController?.navigationBarHidden = true
    }
}
