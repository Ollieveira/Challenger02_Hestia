//
//  OCRView.swift
//  Challenger02_Hestia
//
//  Created by Guilherme Avila on 02/06/24.
//

import SwiftUI
import Foundation
import CropViewController

struct ImageCropperView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var croppedImage: UIImage?
    @Binding var showCropper: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CropViewController {
        let cropViewController = CropViewController(image: image!)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {
    }
    
    class Coordinator: NSObject, CropViewControllerDelegate {
        var parent: ImageCropperView
        
        init(_ parent: ImageCropperView) {
            self.parent = parent
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            parent.croppedImage = image
            parent.showCropper = false
        }
        
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            parent.showCropper = false
        }
    }
}

