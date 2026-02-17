//
//  ImageProcessingUtil.swift
//  Pods
//
//  Created by Karolina Škunca on 30.01.2026..
//

import UIKit

internal final class ImageProcessingUtil {
    
    // MARK: - Configuration
    internal struct Config {
        internal let maxDimension: CGFloat
        internal let jpegQuality: CGFloat
        
        internal init(
            maxDimension: CGFloat = 2024,
            jpegQuality: CGFloat = 0.70
        ) {
            self.maxDimension = maxDimension
            self.jpegQuality = jpegQuality
        }
    }
    
    // MARK: - internal API
    
    /// Compress UIImage → Base64 String
    internal static func imageToCompressedBase64(
        _ image: UIImage,
        config: Config = Config()
    ) -> String? {
        autoreleasepool {
            let resized = image.resizedPreservingAspectRatio(
                maxDimension: config.maxDimension
            )
            
            guard let jpegData = resized.jpegData(
                compressionQuality: config.jpegQuality
            ) else {
                return nil
            }
            
            return jpegData.base64EncodedString()
        }
    }
    
    /// Compress an array of UIImages → [Base64 String]
    internal static func imagesToCompressedBase64(
        _ images: [UIImage],
        config: Config = Config()
    ) -> [String]? {
        var base64Images: [String] = []
        
        for image in images {
            guard let scannedCardBase64Img = imageToCompressedBase64(image) else {
                return nil
            }
            
            base64Images.append(scannedCardBase64Img)
        }
        
        return base64Images
    }
}

private extension UIImage {
    
    /// Resize while preserving aspect ratio
    func resizedPreservingAspectRatio(maxDimension: CGFloat) -> UIImage {
        let maxSide = max(size.width, size.height)
        guard maxSide > maxDimension else { return self }
        
        let scaleRatio = maxDimension / maxSide
        let newSize = CGSize(
            width: size.width * scaleRatio,
            height: size.height * scaleRatio
        )
        
        let format = UIGraphicsImageRendererFormat.preferred()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
