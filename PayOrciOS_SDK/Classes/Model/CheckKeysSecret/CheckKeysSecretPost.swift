//
//  CheckKeysSecretPost.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 20/01/25.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//

import Foundation

public struct CheckKeysSecretPostDataRepresent: Codable {
    let merchantKey: String?
    let merchantSecret: String?
    let env: String?
    
    enum CodingKeys: String, CodingKey {
        case merchantKey = "merchant_key"
        case merchantSecret = "merchant_secret"
        case env
    }
}

public struct CheckKeysSecretSuccessResponse: Codable {
    let message: String?
    let status: String?
    let code: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case status
        case code
    }
}
