//
//  HomeViewModel.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 20/01/25.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//

import Foundation

public class HomeViewModel {
    
    private let networkManager = NetworkManager.shared
    
    var checkKeysSecretSuccessResponse: CheckKeysSecretSuccessResponse?
    var ordersSuccessResponse: CreateOrdersSuccessResponse?
    var transactionDetailsDataResponse: TransactionDetailsDataResponse?

    var errorMessage: String?
    
    // Make the initializer public
    public init() {
        // Initialization code
    }
    
    // Completion handler to pass success or failure response
    public func fetchCreatedOrderDetails(createOrdersPostRepresent :CreateOrdersPostRepresent, completion: @escaping (Result<CreateOrdersSuccessResponse, Error>) -> Void) {
        
        // First, call checkKeysSecret endpoint
        checkKeysSecret { [weak self] result in
            switch result {
            case .success:
                // If checkKeysSecret is successful, call createOrders
                self?.createOrders(createOrdersPostRepresent: createOrdersPostRepresent, completion: completion)
                
            case .failure(let error):
                // If checkKeysSecret fails, pass the error to the completion handler
                completion(.failure(error))
            }
        }
    }
    
    // Private method to handle the checkKeysSecret API call
    private func checkKeysSecret(completion: @escaping (Result<Void, Error>) -> Void) {
        let checkKeysSecretPostDataRepresent = CheckKeysSecretPostDataRepresent(merchantKey: (Configuration.shared.merchantKey ?? ""), merchantSecret: (Configuration.shared.merchantSecret ?? ""), env: (Configuration.shared.environment ?? ""))
        networkManager.request(.checkKeysSecret(checkKeysSecretPostDataRepresent: checkKeysSecretPostDataRepresent)) { [weak self] (result: Result<CheckKeysSecretSuccessResponse, Error>) in
            switch result {
            case .success(let checkKeysSecretSuccessResponse):
                self?.checkKeysSecretSuccessResponse = checkKeysSecretSuccessResponse
                completion(.success(())) // Trigger success for checkKeysSecret
                
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(.failure(error)) // Pass error for checkKeysSecret failure
            }
        }
    }
    
    // Private method to handle the createOrders API call
    private func createOrders(createOrdersPostRepresent :CreateOrdersPostRepresent, completion: @escaping (Result<CreateOrdersSuccessResponse, Error>) -> Void) {
        networkManager.request(.createOrders(createOrdersPostRepresent: createOrdersPostRepresent)) { [weak self] (result: Result<CreateOrdersSuccessResponse, Error>) in
            switch result {
            case .success(let ordersSuccessResponse):
                self?.ordersSuccessResponse = ordersSuccessResponse
                completion(.success(ordersSuccessResponse)) // Pass the success response
                
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(.failure(error)) // Pass the error for createOrders failure
            }
        }
    }
    
    public func fetchOrderTranscationDetails(orderId: String, completion: @escaping (Result<TransactionDetailsDataResponse, Error>) -> Void) {
        networkManager.request(.orderTransactionDetails(orderId: orderId)) { [weak self] (result: Result<TransactionDetailsDataResponse, Error>) in
            switch result {
            case .success(let orderTransactionDetailSuccessResponse):
                self?.transactionDetailsDataResponse = orderTransactionDetailSuccessResponse
                completion(.success(orderTransactionDetailSuccessResponse)) // Pass the success response
                
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(.failure(error)) // Pass the error for createOrders failure
            }
        }
    }
}
