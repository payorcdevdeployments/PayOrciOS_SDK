//
//  WebViewController.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 20/01/25.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//

import UIKit
import WebKit

public class WebViewController: UIViewController {
    
    let gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private weak var webView: WKWebView?
    private let urlString: String
    private let homeViewModel: HomeViewModel
    private weak var delegate: CreateOrdersFormViewControllerDelegate?
    private var timer: Timer?
    private var remainingSeconds = 10
    
    private var bottomView: UIView!
    private var timerLabel: UILabel!
    private var redirectNowLabel: UILabel!
    
//    private var redirectNowButton: UIButton!
    
    public init(aHomeViewModel: HomeViewModel,
                aUrlString: String,
                aDelegate: CreateOrdersFormViewControllerDelegate?) {
        self.homeViewModel = aHomeViewModel
        self.urlString = aUrlString
        self.delegate = aDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Initially hide the back button
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil

        setupWebView()
        setupTimerLabel()
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
        
        setupGifLoader()
    }
    
    private func loadURL() {
        guard let url = URL(string: urlString) else {
            showAlert(message: "Invalid URL")
            return
        }
        // Show the loader while loading the web view.
        showLoader()
        webView?.load(URLRequest(url: url))
    }
    
    private func showAlert(message: String) {
        AlertHelper.showAlert(on: self, message: message)
    }
    
    private func showLoader() {
        self.gifImageView.isHidden = false
        self.gifImageView.startAnimating()
        self.gifImageView.animationDuration = 3
        self.gifImageView.animationRepeatCount = 1
    }
    
    private func hideLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.gifImageView.stopAnimating()
            self.gifImageView.animationImages = nil
            self.gifImageView.isHidden = true
        }
    }
    
    @objc private func handleBackButton() {
        stopTimer()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleRedirectNowButton() {
        stopTimer()
        navigationController?.popViewController(animated: true)
    }

}

//MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoader()
    }

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
        self.startTimer()
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
                        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.handleBackButton))
                    }
                }
            }
        } catch {
            debugPrint("Error parsing JSON: \(error.localizedDescription)")
            showAlert(message: error.localizedDescription)
        }
    }
    
    private func checkPaymentStatus(orderId: String) {
        // Perform payment status check here
        debugPrint("Checking payment status for Order ID: \(orderId)")
        // Add your repository logic
        
        homeViewModel.fetchOrderTranscationDetails(orderId: orderId) { (result: Result<TransactionDetailsDataResponse, Error>) in
            switch result {
            case .success(let orderTranscationDetailsSuccessResponse):
                self.delegate?.didFetchOrderTransactionDetails(orderTranscationDetailsSuccessResponse)

            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
}

extension WebViewController {
    
    func setupGifLoader() {
        webView?.addSubview(gifImageView)
        
        // Load and set the animated image
        gifImageView.image = UIImage.gifImageWithName("spinner-loader")

        // Centering loader
        NSLayoutConstraint.activate([
            gifImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gifImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gifImageView.widthAnchor.constraint(equalToConstant: 50),
            gifImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        gifImageView.isHidden = true  // Initially hidden
    }
}

extension WebViewController {
    
    private func setupTimerLabel() {
        
//        redirectNowButton = UIButton(type: .system)
//        redirectNowButton.frame = CGRect(x: 20,
//                                         y: self.view.frame.size.height - 74,
//                                         width: self.view.frame.size.width - 40,
//                                         height: 44) // (x, y, width, height)
//        redirectNowButton.backgroundColor = UIColor(red: 57/255, green: 131/255, blue: 120/255, alpha: 1) // Corrected color values (0-1 range)
//        redirectNowButton.layer.cornerRadius = 5
//        redirectNowButton.setTitle("Redirect Now", for: .normal)
//        redirectNowButton.setTitleColor(.white, for: .normal)
//        redirectNowButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        redirectNowButton.addTarget(self, action: #selector(handleRedirectNowButton), for: .touchUpInside)
//        redirectNowButton.isHidden = true
        
        bottomView = UIView(frame: CGRect(x: 0,
                                          y: self.view.frame.size.height - 124,
                                          width: self.view.frame.size.width,
                                          height: 124))
        bottomView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        bottomView.isHidden = true
        
        // Create the Hyperlink Label (Redirect Now)
        redirectNowLabel = UILabel(frame: CGRect(x: 20,
                                                 y: bottomView.frame.size.height - 54,
                                                 width: bottomView.frame.size.width - 40,
                                                 height: 34))
        redirectNowLabel.isHidden = true // Initially hidden
        redirectNowLabel.isUserInteractionEnabled = true
        
        let hyperlinkText = "Redirect Now"
        let attributedStringForHyperlinkText = NSMutableAttributedString(string: hyperlinkText)
        
        // Create a paragraph style for center alignment
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        // Set underline and color to mimic a hyperlink
        attributedStringForHyperlinkText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: hyperlinkText.count))
        attributedStringForHyperlinkText.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: hyperlinkText.count))
        attributedStringForHyperlinkText.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .bold), range: NSRange(location: 0, length: hyperlinkText.count))
        attributedStringForHyperlinkText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: hyperlinkText.count))

        redirectNowLabel.attributedText = attributedStringForHyperlinkText


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackButton))
        redirectNowLabel.addGestureRecognizer(tapGesture)

        
        timerLabel = UILabel(frame: CGRect(x: 20,
                                           y: bottomView.frame.size.height - 114,
                                           width: bottomView.frame.size.width - 40,
                                           height: 60))
        timerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        timerLabel.isHidden = true
        timerLabel.numberOfLines = 0
        
        let fullText = "You will be redirected to the merchant site in 5 seconds."
        let attributedString = NSMutableAttributedString(string: fullText)

        // Set black color for the general text
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: fullText.count))

        // Set red color and bold font for the number "5"
        if let range = fullText.range(of: "5") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 22), range: nsRange)
        }

        timerLabel.attributedText = attributedString
        
        view.addSubview(bottomView)
        view.bringSubviewToFront(bottomView)

        bottomView.addSubview(timerLabel)
        bottomView.addSubview(redirectNowLabel)
        
//        webView?.addSubview(redirectNowButton)
        
//        let timerBarButton = UIBarButtonItem(customView: timerLabel)
//        navigationItem.rightBarButtonItem = timerBarButton
    }
    
    private func startTimer() {
        bottomView.isHidden = false
        timerLabel.isHidden = false
        redirectNowLabel.isHidden = false
//        redirectNowButton.isHidden = false
        remainingSeconds = 5
        self.updateTimerLabel()
//        timerLabel.text = "You will be redirected to the merchant site in \(remainingSeconds) seconds."
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingSeconds -= 1
            self.updateTimerLabel()

//            self.timerLabel.text = "You will be redirected to the merchant site in \(self.remainingSeconds) seconds."
            
            if self.remainingSeconds <= 0 {
                self.stopTimer()
                self.delegate?.didFinishPayment()
            }
        }
    }
    
    private func updateTimerLabel() {
        let fullText = "You will be redirected to the merchant site in \(remainingSeconds) seconds."
        let attributedString = NSMutableAttributedString(string: fullText)

        // Set black color for the general text
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: fullText.count))

        // Set red color and bold font for the dynamic number
        if let range = fullText.range(of: "\(remainingSeconds)") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 22), range: nsRange)
        }
        timerLabel.attributedText = attributedString
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerLabel.isHidden = true
        redirectNowLabel.isHidden = true
        bottomView.isHidden = true
//        redirectNowButton.isHidden = true
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Ensure bottomView is on top
        view.bringSubviewToFront(bottomView)
        
        // Adjust webView scroll insets
        let bottomInset = bottomView.frame.height
        webView?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        webView?.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }

}
