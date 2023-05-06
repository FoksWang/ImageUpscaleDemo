//
//  ContentView.swift
//  ImageUpscaleDemo
//
//  Created by Hui Wang on 2023-05-07.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import Kingfisher

struct ContentView: View {
    let imageUrl = URL(string: "your image url")!
    
    @State private var originalImage: UIImage?
    @State private var improvedImage: UIImage?
    @State private var originalSize: CGSize = .zero
    @State private var scaledSize: CGSize = .zero
    @State private var showSliders = false
    @State private var noiseLevel: Float = 0.02
    @State private var sharpness: Float = 0.4
    @State private var unsharpMaskRadius: Float = 2.5
    @State private var unsharpMaskIntensity: Float = 0.8
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    withAnimation {
                        showSliders.toggle()
                    }
                }) {
                    Text("Adjust Image")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                VStack {
                    if let originalImage = originalImage {
                        VStack {
                            Image(uiImage: originalImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: UIScreen.main.bounds.width)
                            Text("Original size: \(Int(originalSize.width)) x \(Int(originalSize.height))")
                        }
                    }
                    
                    if let improvedImage = improvedImage {
                        VStack {
                            Image(uiImage: improvedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: UIScreen.main.bounds.width)
                            Text("Scaled size: \(Int(scaledSize.width)) x \(Int(scaledSize.height))")
                        }
                    }
                }
            }
            .padding()
            
            if showSliders {
                ImageAdjustmentSlidersView(
                    noiseLevel: $noiseLevel,
                    sharpness: $sharpness,
                    unsharpMaskRadius: $unsharpMaskRadius,
                    unsharpMaskIntensity: $unsharpMaskIntensity,
                    onUpdate: updateImage
                )
                .frame(maxHeight: UIScreen.main.bounds.height * 0.3)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5)
                .padding()
            }
        }
        .onAppear(perform: loadImage)
    }
    
    
    func loadImage() {
        KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
            switch result {
            case .success(let value):
                let inputImage = value.image
                originalImage = inputImage
                originalSize = inputImage.size
                
                updateImage()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateImage() {
        if let originalImage = originalImage {
            improvedImage = improveImageQuality(inputImage: originalImage,
                                                scaleFactor: 4.0,
                                                noiseLevel: noiseLevel,
                                                sharpness: sharpness,
                                                unsharpMaskRadius: unsharpMaskRadius,
                                                unsharpMaskIntensity: unsharpMaskIntensity)
            scaledSize = CGSize(width: originalSize.width * 4, height: originalSize.height * 4)
        }
    }
    
    func improveImageQuality(inputImage: UIImage, scaleFactor: CGFloat, noiseLevel: Float, sharpness: Float, unsharpMaskRadius: Float, unsharpMaskIntensity: Float) -> UIImage? {
        guard let inputCGImage = inputImage.cgImage else { return nil }
        let ciImage = CIImage(cgImage: inputCGImage)
        
        let lanczosFilter = CIFilter.lanczosScaleTransform()
        lanczosFilter.inputImage = ciImage
        lanczosFilter.scale = Float(scaleFactor)
        lanczosFilter.aspectRatio = 1.0
        
        guard let lanczosOutputImage = lanczosFilter.outputImage else { return nil }
        
        let noiseReductionFilter = CIFilter.noiseReduction()
        noiseReductionFilter.inputImage = lanczosOutputImage
        noiseReductionFilter.noiseLevel = noiseLevel
        noiseReductionFilter.sharpness = sharpness
        
        guard let noiseReductionOutputImage = noiseReductionFilter.outputImage else { return nil }
        
        let unsharpMaskFilter = CIFilter.unsharpMask()
        unsharpMaskFilter.inputImage = noiseReductionOutputImage
        unsharpMaskFilter.radius = unsharpMaskRadius
        unsharpMaskFilter.intensity = unsharpMaskIntensity
        
        guard let unsharpMaskOutputImage = unsharpMaskFilter.outputImage else { return nil }
        
        let medianFilter = CIFilter.median()
        medianFilter.inputImage = unsharpMaskOutputImage
        
        guard let outputImage = medianFilter.outputImage else { return nil }
        
        let ciContext = CIContext(options: nil)
        guard let outputCGImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
}

struct ImageAdjustmentSlidersView: View {
    @Binding var noiseLevel: Float
    @Binding var sharpness: Float
    @Binding var unsharpMaskRadius: Float
    @Binding var unsharpMaskIntensity: Float
    var onUpdate: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Noise Level: \(String(format: "%.2f", noiseLevel))")
                Slider(value: $noiseLevel, in: 0.0...1.0, step: 0.01) { _ in
                    onUpdate()
                }
            }
            
            HStack {
                Text("Sharpness: \(String(format: "%.2f", sharpness))")
                Slider(value: $sharpness, in: 0.0...1.0, step: 0.01) { _ in
                    onUpdate()
                }
            }
            
            HStack {
                Text("Unsharp Mask Radius: \(String(format: "%.1f", unsharpMaskRadius))")
                Slider(value: $unsharpMaskRadius, in: 0.0...5.0, step: 0.1) { _ in
                    onUpdate()
                }
            }
            
            HStack {
                Text("Unsharp Mask Intensity: \(String(format: "%.2f", unsharpMaskIntensity))")
                Slider(value: $unsharpMaskIntensity, in: 0.0...1.0, step: 0.01) { _ in
                    onUpdate()
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
