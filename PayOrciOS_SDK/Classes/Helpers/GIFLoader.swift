//
//  GIFLoader.swift
//  PayOrciOS_SDK
//
//  Created by PayOrc on 02/02/25.
//  Copyright (c) 2025 PayOrc. All rights reserved.
//

import UIKit
import ImageIO

public class GIFLoader {
    public static func loadGIF(named name: String) -> UIImage? {
        guard let gifUrl = Bundle.main.url(forResource: name, withExtension: "gif"),
              let gifData = try? Data(contentsOf: gifUrl) else {
            return nil
        }
        return animatedGIF(with: gifData)
    }

    private static func animatedGIF(with data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        
        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var duration: Double = 0.0
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let frameDuration = frameDuration(at: i, source: source)
                duration += frameDuration
                images.append(UIImage(cgImage: cgImage))
            }
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
    }

    private static func frameDuration(at index: Int, source: CGImageSource) -> Double {
        let defaultFrameDuration = 0.1
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
              let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? Double,
              delayTime > 0 else {
            return defaultFrameDuration
        }
        return delayTime
    }
}

//extension CreateOrdersFormViewController {
//    func showGIFLoader() {
//        if let gifImage = GIFLoader.loadGIF(named: "spinner-loader") {
//            let imageView = UIImageView(image: gifImage)
//
//            // Set size for the loader (adjust as needed)
//            let loaderSize: CGFloat = 100
//
//            // Position it in the center of the screen
//            imageView.frame = CGRect(x: 0, y: 0, width: loaderSize, height: loaderSize)
//            imageView.center = view.center
//
//            // Optional: Make sure it’s above other UI elements
//            imageView.layer.zPosition = 9999
//
//            // Set a tag to identify the loader later
//            imageView.tag = 999
//
//            // Add the loader to the main view
//            view.addSubview(imageView)
//            view.bringSubviewToFront(imageView)
//
//            // Store reference for later removal
//            gifImageView = imageView
//        }
//    }
//
//    func hideGIFLoader() {
//        gifImageView?.removeFromSuperview()
//        gifImageView = nil
//    }
//}
