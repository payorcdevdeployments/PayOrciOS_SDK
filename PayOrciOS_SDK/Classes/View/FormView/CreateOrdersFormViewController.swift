//
//  CreateOrdersFormViewController.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 30/01/25.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//

import UIKit
import KRProgressHUD

// MARK: - ViewController
public class CreateOrdersFormViewController: UIViewController, UIScrollViewDelegate {
    
    private let homeViewModel = HomeViewModel()
    
    // ScrollView and ContentView
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Elements
    private let classNameTextField = UITextField()
    private let actionTextField = UITextField()
    private let captureMethodTextField = UITextField()
    private let paymentTokenTextField = UITextField()
    
    // Order Details
    private let orderIdTextField = UITextField()
    private let amountTextField = UITextField()
    private let convenienceFeeTextField = UITextField()
    private let quantityTextField = UITextField()
    private let currencyTextField = UITextField()
    private let descriptionTextField = UITextField()
    
    // Customer Details
    private let customerIdTextField = UITextField()
    private let customerNameTextField = UITextField()
    private let customerEmailTextField = UITextField()
    private let customerMobileTextField = UITextField()
    private let customerCodeTextField = UITextField()
    
    // Billing Details
    private let billingAddress1TextField = UITextField()
    private let billingAddress2TextField = UITextField()
    private let billingCityTextField = UITextField()
    private let billingProvinceTextField = UITextField()
    private let billingCountryTextField = UITextField()
    private let billingPinTextField = UITextField()
    
    // Shipping Details
    private let shippingNameTextField = UITextField()
    private let shippingEmailTextField = UITextField()
    private let shippingCodeTextField = UITextField()
    private let shippingMobileTextField = UITextField()
    private let shippingAddress1TextField = UITextField()
    private let shippingAddress2TextField = UITextField()
    private let shippingCityTextField = UITextField()
    private let shippingProvinceTextField = UITextField()
    private let shippingCountryTextField = UITextField()
    private let shippingPinTextField = UITextField()
    private let locationPinTextField = UITextField()
    private let shippingCurrencyTextField = UITextField()
    private let shippingAmountTextField = UITextField()
    
    // URLs
    private let successURLTextField = UITextField()
    private let cancelURLTextField = UITextField()
    private let failureURLTextField = UITextField()

    // Submit Button
    private let submitButton = UIButton(type: .system)
    
    private var fields = [UIStackView]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        title = "PayOrc Payment Request"
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.blue,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular) // Set font size and weight
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        // Add Pre-Fill button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pre-Fill", style: .plain, target: self, action: #selector(preFillData))
        
        // Add "Dismiss" button to the left
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissView))

        setupUI()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupUI() {
        
        // Configure ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        // Configure ContentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Create and configure text fields
        fields = [
            createLabelAndTextField(labelText: "Class Name", textField: classNameTextField),
            createLabelAndTextField(labelText: "Action", textField: actionTextField),
            createLabelAndTextField(labelText: "Capture Method", textField: captureMethodTextField),
            createLabelAndTextField(labelText: "Payment Token", textField: paymentTokenTextField),
            
            // Order Details
            createLabelAndTextField(labelText: "Order ID", textField: orderIdTextField),
            createLabelAndTextField(labelText: "Amount", textField: amountTextField),
            createLabelAndTextField(labelText: "Convenience Fee", textField: convenienceFeeTextField),
            createLabelAndTextField(labelText: "Quantity", textField: quantityTextField),
            createLabelAndTextField(labelText: "Currency", textField: currencyTextField),
            createLabelAndTextField(labelText: "Description", textField: descriptionTextField),
            
            // Customer Details
            createLabelAndTextField(labelText: "Customer ID", textField: customerIdTextField),
            createLabelAndTextField(labelText: "Customer Name", textField: customerNameTextField),
            createLabelAndTextField(labelText: "Customer Email", textField: customerEmailTextField),
            createLabelAndTextField(labelText: "Customer Mobile", textField: customerMobileTextField),
            createLabelAndTextField(labelText: "Customer Code", textField: customerCodeTextField),
            
            // Billing Details
            createLabelAndTextField(labelText: "Billing Address Line 1", textField: billingAddress1TextField),
            createLabelAndTextField(labelText: "Billing Address Line 2", textField: billingAddress2TextField),
            createLabelAndTextField(labelText: "Billing City", textField: billingCityTextField),
            createLabelAndTextField(labelText: "Billing Province", textField: billingProvinceTextField),
            createLabelAndTextField(labelText: "Billing Country", textField: billingCountryTextField),
            createLabelAndTextField(labelText: "Billing PIN", textField: billingPinTextField),
            
            // Shipping Details
            createLabelAndTextField(labelText: "Shipping Name", textField: shippingNameTextField),
            createLabelAndTextField(labelText: "Shipping Email", textField: shippingEmailTextField),
            createLabelAndTextField(labelText: "Shipping Code", textField: shippingCodeTextField),
            createLabelAndTextField(labelText: "Shipping Mobile", textField: shippingMobileTextField),
            createLabelAndTextField(labelText: "Shipping Address Line 1", textField: shippingAddress1TextField),
            createLabelAndTextField(labelText: "Shipping Address Line 2", textField: shippingAddress2TextField),
            createLabelAndTextField(labelText: "Shipping City", textField: shippingCityTextField),
            createLabelAndTextField(labelText: "Shipping Province", textField: shippingProvinceTextField),
            createLabelAndTextField(labelText: "Shipping Country", textField: shippingCountryTextField),
            createLabelAndTextField(labelText: "Shipping PIN", textField: shippingPinTextField),
            createLabelAndTextField(labelText: "Location PIN", textField: locationPinTextField),
            createLabelAndTextField(labelText: "Shipping Currency", textField: shippingCurrencyTextField),
            createLabelAndTextField(labelText: "Shipping Amount", textField: shippingAmountTextField),
            
            // URLs
            createLabelAndTextField(labelText: "Success URL", textField: successURLTextField),
            createLabelAndTextField(labelText: "Cancel URL", textField: cancelURLTextField),
            createLabelAndTextField(labelText: "Failure URL", textField: failureURLTextField)
        ]
        
        var previousView: UIView? = nil
        for (index, field) in fields.enumerated() {
            contentView.addSubview(field)
            field.translatesAutoresizingMaskIntoConstraints = false
            field.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            field.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            
            if let previousView = previousView {
                field.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 8).isActive = true
            } else {
                field.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
            }
            
            // Set return key type for text fields
            if let textField = field.arrangedSubviews[1] as? UITextField {
                if index == fields.count - 1 {
                    // Last field: Done
                    textField.returnKeyType = .done
                } else {
                    // All other fields: Next
                    textField.returnKeyType = .next
                }
                
                // Set the delegate for each text field
                textField.delegate = self
            }
            
            previousView = field
        }
        // Submit Button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(submitButton)
        
        if let lastField = previousView {
            lastField.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -16).isActive = true
        }
        
        submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        // Constraints for ScrollView and ContentView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func preFillData() {
        
        classNameTextField.text = "ECOM"
        actionTextField.text = "SALE"
        captureMethodTextField.text = "MANUAL"
        paymentTokenTextField.text = ""

        // Order Details
        orderIdTextField.text = "1234"
        amountTextField.text = "100"
        convenienceFeeTextField.text = "0"
        quantityTextField.text = "2"
        currencyTextField.text = "AED"
        descriptionTextField.text = ""

        // Customer Details
        customerIdTextField.text = "123"
        customerNameTextField.text = "John Doe"
        customerEmailTextField.text = "pawan@payorc.com"
        customerMobileTextField.text = "987654321"
        customerCodeTextField.text = "971"

        // Billing Details
        billingAddress1TextField.text = "address 1"
        billingAddress2TextField.text = "address 2"
        billingCityTextField.text = "Amarpur"
        billingProvinceTextField.text = "Bihar"
        billingCountryTextField.text = "IN"
        billingPinTextField.text = "482008"

        // Shipping Details
        shippingNameTextField.text = "Pawan Kushwaha"
        shippingEmailTextField.text = ""
        shippingCodeTextField.text = "91"
        shippingMobileTextField.text = "9876543210"
        shippingAddress1TextField.text = "address 1"
        shippingAddress2TextField.text = "address 2"
        shippingCityTextField.text = "Jabalpur"
        shippingProvinceTextField.text = "Madhya Pradesh"
        shippingCountryTextField.text = "IN"
        shippingPinTextField.text = "482005"
        locationPinTextField.text = "https://location/somepoint"
        shippingCurrencyTextField.text = "AED"
        shippingAmountTextField.text = "10"

        // URLs
        successURLTextField.text = ""
        cancelURLTextField.text = ""
        failureURLTextField.text = ""
        
        debugPrint("Pre-filled form with sample data")
    }
}

extension CreateOrdersFormViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let index = fields.firstIndex(where: { $0.arrangedSubviews[1] == textField }) {
            if index < fields.count - 1 {
                // Move to the next field
                if let nextTextField = fields[index + 1].arrangedSubviews[1] as? UITextField {
                    nextTextField.becomeFirstResponder()
                }
            } else {
                // Submit the form for the last field
                handleSubmit()
            }
        }
        return true
    }
}

extension CreateOrdersFormViewController {
    private func createLabelAndTextField(labelText: String, textField: UITextField) -> UIStackView {
        let label = UILabel()
        label.text = labelText
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        textField.placeholder = "Enter \(labelText.lowercased())" // Setting placeholder
        
        let stackView = UIStackView(arrangedSubviews: [label, textField])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }
    
    @objc private func handleSubmit() {
        // Handle form submission
        debugPrint("Form submitted")
        
        let createOrderDetailsDataRepresent = CreateOrderDetailsDataRepresent(mOrderId: orderIdTextField.text, amount: amountTextField.text, convenienceFee: convenienceFeeTextField.text, quantity: quantityTextField.text, currency: currencyTextField.text, description: descriptionTextField.text)
        
        let customerDetailsDataRepresent = CustomerDetailsDataRepresent(mCustomerId: customerIdTextField.text, name: customerNameTextField.text, email: customerEmailTextField.text, mobile: customerMobileTextField.text, code: customerCodeTextField.text)

        let billingDetailsDataRepresent = BillingDetailsDataRepresent(addressLine1: billingAddress1TextField.text, addressLine2: billingAddress2TextField.text, city: billingCityTextField.text, province: billingProvinceTextField.text, country: billingCountryTextField.text, pin: billingPinTextField.text)
        
        let shippingDetailsDataRepresent = ShippingDetailsDataRepresent(shippingName: shippingNameTextField.text, shippingEmail: shippingEmailTextField.text, shippingCode: shippingCodeTextField.text, shippingMobile: shippingMobileTextField.text, addressLine1: shippingAddress1TextField.text, addressLine2: shippingAddress2TextField.text, city: shippingCityTextField.text, province: shippingProvinceTextField.text, country: shippingCountryTextField.text, pin: shippingPinTextField.text, locationPin: locationPinTextField.text, shippingCurrency: shippingCurrencyTextField.text, shippingAmount: shippingAmountTextField.text)
        
        //location pin field value = "https://location/somepoint"

        let urlsDataRepresent = UrlsDataRepresent(success: successURLTextField.text, cancel: cancelURLTextField.text, failure: failureURLTextField.text)
        
        let customDataRepresent = [CustomDataRepresent(alpha: "", beta: "", gamma: "", delta: "", epsilon: "")]
        
        let createOrdersPostDataRepresent = CreateOrdersPostDataRepresent(classKey: classNameTextField.text, action: actionTextField.text, captureMethod: captureMethodTextField.text, paymentToken: paymentTokenTextField.text, orderDetails: createOrderDetailsDataRepresent, customerDetails: customerDetailsDataRepresent, billingDetails: billingDetailsDataRepresent, shippingDetails: shippingDetailsDataRepresent, urls: urlsDataRepresent, parameters: customDataRepresent, customData: customDataRepresent)

        let createOrdersPostRepresent = CreateOrdersPostRepresent(data: createOrdersPostDataRepresent)

        showLoader()
        homeViewModel.fetchCreatedOrderDetails(createOrdersPostRepresent: createOrdersPostRepresent) { (result: Result<CreateOrdersSuccessResponse, Error>) in
            hideLoader()  // Hide the loader after completion

            switch result {
            case .success(let ordersSuccessResponse):
                guard let iframeLink = ordersSuccessResponse.iframeLink else {
                    showAlert(message: "Invalid response: iframe link not found.")
                    return
                }
                navigateToWebView(with: iframeLink)

            case .failure(let error):
                showAlert(message: error.localizedDescription)
            }
        }

        func navigateToWebView(with urlString: String) {
            let webViewController = WebViewController(urlString: urlString)
            navigationController?.pushViewController(webViewController, animated: true)
        }
        
        func showAlert(message: String) {
            AlertHelper.showAlert(on: self, message: message)
        }

        func showLoader() {
            KRProgressHUD.showOn(self).show()
        }

        func hideLoader() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                KRProgressHUD.dismiss()
            }
        }
    }
}
