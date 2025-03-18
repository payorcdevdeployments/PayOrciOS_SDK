//
//  Constants.swift
//  PayOrciOS_SDK
//
//  Created by PayOrc on 30/01/25.
//  Copyright (c) 2025 PayOrc. All rights reserved.
//


import Foundation

public struct AppConstants {
    public static let marketingVersion: String = {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }()
}
