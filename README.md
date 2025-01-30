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


## Usage

(see sample Xcode project in /Example)

First, import PayOrciOS_SDK in the required Swift file, such as AppDelegate.
After that, in didFinishLaunchingWithOptions, provide the required configuration fields, including Base URL, API version, merchant key, merchant secret, and environment (the environment string should be "dev", "test", "staging", or "production").

This configuration must be set during app launch.
If it is not provided or is missing, an error will be returned from the API service.

```
PayOrciOS_SDK.Configuration.shared.updateConfigurationDetails("https://example.com/api/", apiVersion: "v1", merchantKey: "", merchantSecret: "", environment: "test")
```

## Author

ramanocs1145

## License

PayOrciOS_SDK is available under the MIT license. See the LICENSE file for more info.
