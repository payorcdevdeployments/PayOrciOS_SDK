//
//  ViewController.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 01/23/2025.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//

import UIKit
import PayOrciOS_SDK

class ViewController: UIViewController {
    private let payOrcPaymentRequestButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .cyan
        button.titleLabel?.textColor = .white
        button.setTitle("PayOrc Payment Request", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupUI() {
        payOrcPaymentRequestButton.layer.cornerRadius = 20
        payOrcPaymentRequestButton.layer.masksToBounds = true
        payOrcPaymentRequestButton.addTarget(self, action: #selector(makeNavigatePayOrcPaymentRequestForm), for: .touchUpInside)

        view.addSubview(payOrcPaymentRequestButton)
        
        NSLayoutConstraint.activate([
            
            payOrcPaymentRequestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payOrcPaymentRequestButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            payOrcPaymentRequestButton.widthAnchor.constraint(equalToConstant: 250),
            payOrcPaymentRequestButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
        
    @objc
    private func makeNavigatePayOrcPaymentRequestForm() {
        let formVC = CreateOrdersFormViewController()
        formVC.delegate = self
        let navController = UINavigationController(rootViewController: formVC)
        navController.modalPresentationStyle = .fullScreen // Optional: Adjust presentation style
        present(navController, animated: true, completion: nil)
    }
}

extension ViewController: CreateOrdersFormViewControllerDelegate {
    func didFetchOrderTransactionDetails(_ transactionDetails: PayOrciOS_SDK.TransactionDetailsDataResponse) {
        debugPrint("PayOrciOS_SDK: didFetchOrderTransactionDetails \(transactionDetails)")
    }
    
    func didFinishPayment() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.dismiss(animated: true, completion: {
                self.showToast(message: "Payment successfully completed")
            })
        }
    }
}

extension ViewController {
    private func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: 20,
                                               y: self.view.frame.size.height - 100,
                                               width: self.view.frame.size.width - 40,
                                               height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 2.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
