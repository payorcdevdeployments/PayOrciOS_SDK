//
//  Constants.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 30/01/25.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//


import Foundation

public struct AppConstants {
    public static let marketingVersion: String = {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }()
}
