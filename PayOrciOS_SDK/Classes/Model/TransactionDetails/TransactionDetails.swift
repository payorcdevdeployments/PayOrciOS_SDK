//
//  TransactionDetails.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 31/01/25.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//

import Foundation

public struct TransactionDetailsDataResponse: Codable {
    let data: TransactionDetailsSuccessResponse?
    let message: String?
    let status: String?
    let code: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case status
        case code
    }
}

// Model to represent the success response
public struct TransactionDetailsSuccessResponse: Codable {
    let mOrderId: String?
    let pOrderId: String?
    let pRequestId: Double?
    let pspRefId: String?
    let transactionId: String?
    let pspTxnId: String?
    let transactionDate: String?
    let status: String?
    let currency: String?
    let amount: String?
    let amountCaputred: String?
    let psp: String?
    let paymentMethod: String?
    let mCustomerId: String?
    let mPaymentToken: String?
    let paymentMethodData: PaymentMethodDataRepresent?
    let apmName: String?
    let apmIdentifier: String?
    let subMerchantIdentifier: String?
    let transactionHistory: [TransactionHistoryDataRepresent]?
    let channel: String?
    let parameters: [CustomDataRepresent]?
    let customData: [CustomDataRepresent]?

    enum CodingKeys: String, CodingKey {
        case status
        case pOrderId = "p_order_id"
        case mOrderId = "m_order_id"
        case pRequestId = "p_request_id"
        case amount
        case pspRefId = "psp_ref_id"
        case transactionId = "transaction_id"
        case pspTxnId = "psp_txn_id"
        case transactionDate = "transaction_date"
        case currency
        case amountCaputred = "amount_caputred"
        case psp
        case paymentMethod = "payment_method"
        case mCustomerId = "m_customer_id"
        case mPaymentToken = "m_payment_token"
        case paymentMethodData = "payment_method_data"
        case apmName = "apm_name"
        case apmIdentifier = "apm_identifier"
        case subMerchantIdentifier = "sub_merchant_identifier"
        case transactionHistory = "transaction_history"
        case channel
        case parameters
        case customData = "custom_data"
    }
    
    public struct PaymentMethodDataRepresent: Codable {
        let scheme: String?
        let cardCountry: String?
        let cardType: String?
        let maskedPan: String?
        
        enum CodingKeys: String, CodingKey {
            case scheme
            case cardCountry = "card_country"
            case cardType = "card_type"
            case maskedPan = "masked_pan"
        }
    }
}

public struct TransactionHistoryDataRepresent: Codable {
    let orderId: String?
    let transactionId: String?
    let type: String?
    let status: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case transactionId = "transaction_id"
        case type
        case status
        case createdAt = "created_at"
    }
}

