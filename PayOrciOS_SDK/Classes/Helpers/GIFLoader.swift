//
//  GIFLoader.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 02/02/25.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
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
