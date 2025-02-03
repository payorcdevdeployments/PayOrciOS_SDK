//
//  DeviceInfo.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 30/01/25.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//

import UIKit

public struct DeviceInfo {
    public static let sdk: String = "iOS" // All iOS devices are Apple devices
    public static let brand: String = "Apple" // All iOS devices are Apple devices
    public static let model: String = UIDevice.current.model // e.g., "iPhone", "iPad"
    public static let deviceName: String = UIDevice.current.name // e.g., "John’s iPhone"
    public static let osVersion: String = UIDevice.current.systemVersion // e.g., "17.2"
    public static let systemName: String = UIDevice.current.systemName // e.g., "iOS"
}

