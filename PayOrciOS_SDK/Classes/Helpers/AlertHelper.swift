//
//  AlertHelper.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 20/01/25.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//

import UIKit

public class AlertHelper {
    public static func showAlert(on viewController: UIViewController, title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}
