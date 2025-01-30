# PayOrciOS_SDK

[![Version](https://img.shields.io/cocoapods/v/PayOrciOS_SDK.svg?style=flat)](https://cocoapods.org/pods/PayOrciOS_SDK)
[![License](https://img.shields.io/cocoapods/l/PayOrciOS_SDK.svg?style=flat)](https://cocoapods.org/pods/PayOrciOS_SDK)
[![Platform](https://img.shields.io/cocoapods/p/PayOrciOS_SDK.svg?style=flat)](https://cocoapods.org/pods/PayOrciOS_SDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Requirements

Xcode 12.0+
iOS   13.0+
Swift 5.0+


## Dependencies

This project uses the following dependencies:

Dependency    Version
Moya             15.0
KRProgressHUD    3.4.4


## Installation

PayOrciOS_SDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PayOrciOS_SDK'
```

## CocoaPods
To install dependencies, run:
```bash
pod install
```

## Usage

## Step 1:

(see sample Xcode project in /Example)

First, import PayOrciOS_SDK in the required Swift file, such as AppDelegate.
After that, in didFinishLaunchingWithOptions, provide the required configuration fields, including Base URL, API version, merchant key, merchant secret, and environment (the environment string should be "dev", "test", "staging", or "production").

This configuration must be set during app launch.
If it is not provided or is missing, an error will be returned from the API service.

```
PayOrciOS_SDK.Configuration.shared.updateConfigurationDetails("https://example.com/api/", apiVersion: "v1", merchantKey: "", merchantSecret: "", environment: "test")
```

## Step 2:

You need to create PayOrcPaymentRequestForm to make payment request. If you want to do the custom UI for PayOrcPaymentRequestForm do it on your side. Once done you will replace with your custom UIViewController instead of using CreateOrdersFormViewController. If you want to keep our existing PayOrcPaymentRequestForm UI, you just check and follow the Example for PayOrciOS_SDK. 

```
    @objc
    private func makeNavigatePayOrcPaymentRequestForm() {
        let formVC = CreateOrdersFormViewController()
        let navController = UINavigationController(rootViewController: formVC)
        navController.modalPresentationStyle = .fullScreen // Optional: Adjust presentation style
        present(navController, animated: true, completion: nil)
    }
```

## Step 3:

payment request object reference.

```
PayOrcPaymentRequest(
    data: Data(
      className: PayOrcClass.ecom.name.toUpperCase(),
      action: PayOrcAction.sale.name.toUpperCase(),
      captureMethod: PayOrcCaptureMethod.manual.name.toUpperCase(),
      paymentToken: "",
      orderDetails: OrderDetails(
        mOrderId: "1234",
        amount: "500",
        convenienceFee: "0",
        quantity: "1",
        currency: "AED",
        description: "",
      ),
      customerDetails: CustomerDetails(
        mCustomerId: "123",
        name: "John Doe",
        email: "johndoe@example.com",
        mobile: "987654321",
        code: "971",
      ),
      billingDetails: BillingDetails(
        addressLine1: "address 1",
        addressLine2: "address 2",
        city: "Amarpur",
        province: "Bihar",
        country: "IN",
        pin: "482008",
      ),
      shippingDetails: ShippingDetails(
        shippingName: "John Doe",
        shippingEmail: "",
        shippingCode: "91",
        shippingMobile: "9876543210",
        addressLine1: "address 1",
        addressLine2: "address 2",
        city: "Mumbai",
        province: "Maharashtra",
        country: "IN",
        pin: "482005",
        locationPin: "https://www.google.com/maps?q=24.227923067092433,80.07790793685352",
        shippingCurrency: "AED",
        shippingAmount: "10",
      ),
      urls: Urls(
        success: "",
        cancel: "",
        failure: "",
      ),
      parameters: [
        {
          "alpha": "",
        },
        {
          "beta": "",
        },
        {
          "gamma": "",
        },
        {
          "delta": "",
        },
        {
          "epsilon": "",
        }
      ],
      customData: [
        {
          "alpha": "",
        },
        {
          "beta": "",
        },
        {
          "gamma": "",
        },
        {
          "delta": "",
        },
        {
          "epsilon": "",
        }
      ],
    ),
);
```

## Note :

All fields are mandatory
When there is no data for a field you should send it as empty String not pass null


## Step 4:

To fetch payment transaction status use p_order_id from create payment response.



## Author

ramanocs1145


## License

PayOrciOS_SDK is available under the MIT license. See the LICENSE file for more info.
