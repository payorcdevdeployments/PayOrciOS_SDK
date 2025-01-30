//
//  CreateOrdersFormField.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 30/01/25.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//

import UIKit

// MARK: - Models
public struct FormField {
    let title: String
    let placeholder: String
    var value: String?
    let keyboardType: UIKeyboardType
    let validation: ((String) -> Bool)?
}

public struct FormSection {
    let title: String
    var fields: [FormField]
}
