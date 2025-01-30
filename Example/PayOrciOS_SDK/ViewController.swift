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
    private let fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle("Fetch Orders", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupUI() {
        fetchButton.addTarget(self, action: #selector(fetchUserData), for: .touchUpInside)

        view.addSubview(fetchButton)
        
        NSLayoutConstraint.activate([
            
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fetchButton.widthAnchor.constraint(equalToConstant: 200),
            fetchButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
        
    @objc
    private func fetchUserData() {
        let formVC = CreateOrdersFormViewController()
        let navController = UINavigationController(rootViewController: formVC)
        navController.modalPresentationStyle = .fullScreen // Optional: Adjust presentation style
        present(navController, animated: true, completion: nil)
    }
}
