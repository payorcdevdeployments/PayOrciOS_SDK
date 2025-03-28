//
//  APIService.swift
//  PayOrciOS_SDK
//
//  Created by PayOrc on 20/01/25.
//  Copyright (c) 2025 PayOrc. All rights reserved.
//

import Moya

enum APIService {
    case checkKeysSecret(checkKeysSecretPostDataRepresent :CheckKeysSecretPostDataRepresent)
    case createOrders(createOrdersPostRepresent :CreateOrdersPostRepresent)
    case orderTransactionDetails(orderId: String)  // Accept orderId as a query parameter
}

extension APIService: TargetType {
    var path: String {
        switch self {
        case .checkKeysSecret:
            return (Configuration.shared.apiVersion ?? "") + "/check/keys-secret"
        case .createOrders:
            return (Configuration.shared.apiVersion ?? "") + "/sdk/orders/create"
        case .orderTransactionDetails(_):
            return (Configuration.shared.apiVersion ?? "") + "/sdk/orders/transaction-details"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkKeysSecret, .createOrders:
            return .post
        case .orderTransactionDetails:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkKeysSecret(let checkKeysSecretPostDataRepresent):
            // Print the JSON string before encoding it
            printJSON(checkKeysSecretPostDataRepresent)
            
            // Encoding the parameters into the request body as JSON
            return .requestJSONEncodable(checkKeysSecretPostDataRepresent)
            
        case .createOrders(let createOrdersPostRepresent):
            // Print the JSON string before encoding it
            printJSON(createOrdersPostRepresent)
            
            // Encoding the parameters into the request body as JSON
            return .requestJSONEncodable(createOrdersPostRepresent)
            
        case .orderTransactionDetails(let orderId):
            return .requestParameters(parameters: ["p_order_id": orderId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .checkKeysSecret(_), .orderTransactionDetails:
            return [
                "merchant-key": (Configuration.shared.merchantKey ?? ""),
                "merchant-secret": (Configuration.shared.merchantSecret ?? ""),
                "Content-Type": "application/json"
            ]
            
        case .createOrders(_):
            return [
                "merchant-key": (Configuration.shared.merchantKey ?? ""),
                "merchant-secret": (Configuration.shared.merchantSecret ?? ""),
                "sdk": DeviceInfo.sdk,
                "sdk-version": AppConstants.marketingVersion,
                "device-brand": DeviceInfo.brand,
                "device-model": DeviceInfo.model,
                "device-os-version": DeviceInfo.osVersion,
                "Content-Type": "application/json"
            ]
        }
    }
    
    var baseURL: URL {
        return URL(string: (Configuration.shared.baseURL ?? ""))! //"https://nodeserver.payorc.com/api/"
    }
    
    // Generic method to print any Encodable object as JSON
    private func printJSON<T: Encodable>(_ object: T) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(object)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                debugPrint("JSON String for \(T.self): \(jsonString)")
            }
        } catch {
            debugPrint("Failed to encode \(T.self) to JSON: \(error.localizedDescription)")
        }
    }
}
