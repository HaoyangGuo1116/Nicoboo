//
//  GIFView.swift
//  Nicoboo
//
//  Created for GIF animation support
//

import SwiftUI
import UIKit

struct GIFView: UIViewRepresentable {
    let gifName: String
    let isAnimating: Bool
    
    init(gifName: String, isAnimating: Bool = true) {
        self.gifName = gifName
        self.isAnimating = isAnimating
    }
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        // Load GIF from bundle
        guard let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
              let data = NSData(contentsOfFile: path),
              let source = CGImageSourceCreateWithData(data, nil) else {
            print("Warning: Could not load GIF file: \(gifName).gif")
            return imageView
        }
        
        // Get frame count
        let frameCount = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var totalDuration: TimeInterval = 0
        
        // Extract frames and durations
        for i in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                continue
            }
            
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            
            // Get frame duration
            if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
               let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
               let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? TimeInterval {
                totalDuration += delayTime
            } else {
                totalDuration += 0.1 // Default frame duration
            }
        }
        
        // Create animated image
        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        imageView.animationRepeatCount = 0 // Infinite loop
        
        if isAnimating {
            imageView.startAnimating()
        }
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        // Start or stop animation based on isAnimating state
        if isAnimating && !uiView.isAnimating {
            uiView.startAnimating()
        } else if !isAnimating && uiView.isAnimating {
            uiView.stopAnimating()
        }
    }
}

