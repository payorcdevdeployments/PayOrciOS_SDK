//
//  WebViewController.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 20/01/25.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//

import UIKit
import WebKit
import KRProgressHUD

public class WebViewController: UIViewController {
    private weak var webView: WKWebView?
    private let urlString: String
    
    public init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        
        // Initially hide the back button
        self.navigationItem.hidesBackButton = true

        setupWebView()
        loadURL()
    }
    
    private func setupWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "iOSBridge")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.webView = webView
    }
    
    private func loadURL() {
        guard let url = URL(string: urlString) else {
            showAlert(message: "Invalid URL")
            return
        }
        // Show the loader while loading the web view.
        showLoader()
        self.webView?.load(URLRequest(url: url))
    }
    
    private func showAlert(message: String) {
        AlertHelper.showAlert(on: self, message: message)
    }
    
    private func showLoader() {
        KRProgressHUD.set(style: KRProgressHUDStyle.custom(background: UIColor.gray, text: UIColor.black, icon: UIColor.black))
        KRProgressHUD.showOn(self).show()
    }
    
    private func hideLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            KRProgressHUD.dismiss()
        }
    }
}

//MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    // WKNavigationDelegate methods
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Hide the loader once the page finishes loading
        hideLoader()
        
        let script = """
                     console.log("Injecting JavaScript...");
                     var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
                     var eventer = window[eventMethod];
                     var messageEvent = eventMethod === "attachEvent" ? "onmessage" : "message";
                     
                     eventer(messageEvent, function(e) {
                        console.log("Message received: ", e.data);
                        window.webkit.messageHandlers.iOSBridge.postMessage(e.data);
                     }, false);
                     """
        
        webView.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                debugPrint("Error injecting script: \(error.localizedDescription)")
            } else {
                debugPrint("JavaScript injected successfully")
            }
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Hide the loader in case of error.
        hideLoader()
        showAlert(message: "Failed to load the page: \(error.localizedDescription)")
    }
}

//MARK: - WKScriptMessageHandler
extension WebViewController: WKScriptMessageHandler{
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard (message.name == "iOSBridge") else { return }
        if let data = message.body as? String {
            handlePostMessage(data: data)
        } else {
            debugPrint("Invalid message format")
        }
    }
    
    private func handlePostMessage(data: String) {
        do {
            let jsonData = data.data(using: .utf8)!
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                debugPrint("Received data: \(jsonObject)")
                
                if let pOrderId = jsonObject["p_order_id"] as? String, !pOrderId.isEmpty {
                    // Handle the payment status check
                    debugPrint("Payment Order ID: \(pOrderId)")
                    checkPaymentStatus(orderId: pOrderId)
                    
                    // Once condition is met, show the back button
                    DispatchQueue.main.async {
                        self.navigationItem.hidesBackButton = false
                    }
                }
            }
        } catch {
            debugPrint("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    private func checkPaymentStatus(orderId: String) {
        // Perform payment status check here
        debugPrint("Checking payment status for Order ID: \(orderId)")
        // Add your repository logic
    }
}
