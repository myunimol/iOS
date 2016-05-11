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
    
    private var request : NSURLRequest {
        let baseUrl = "https://unimol.esse3.cineca.it/auth/Logon.do"
        let URL = NSURL(string: baseUrl)!
        return NSURLRequest(URL: URL)
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
    
    
    override func viewDidLoad() {
        /* Create our preferences on how the web page should be loaded */
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false
        
        /* Create a configuration for our preferences */
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        /* Now instantiate the web view */
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        
        if let theWebView = webView{
            /* Load a web page into our web view */
            //let url = NSURL(string: "http://www.apple.com")
            let urlRequest = self.request
            theWebView.loadRequest(urlRequest)
            theWebView.navigationDelegate = self
            view.addSubview(theWebView)
        }
    }
    
    func connection(connection: NSURLConnection, willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge){
        
        if challenge.protectionSpace.host == "unimol.esse3.cineca.it/auth/Logon.do" {
            let user = "g.grano"
            let password = "undell3gas"
            let credential = NSURLCredential(user: user, password: password, persistence: NSURLCredentialPersistence.ForSession)
            challenge.sender!.useCredential(credential, forAuthenticationChallenge: challenge)
        }
    }
}
