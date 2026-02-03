//
//  CameraManager.swift
//  Monri
//
//  Created by Karolina Škunca on 03.02.2026..
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraManagerDelegate: AnyObject {
    func didCapturePhoto(_ image: UIImage)
    func didFailToCapture(with error: Error)
}

enum CameraError: LocalizedError {
    case noCameraAvailable
    case failedToProcessImage
    case failedToSetupCamera
    
    var errorDescription: String? {
        switch self {
        case .noCameraAvailable:
            return "No camera available on this device"
        case .failedToProcessImage:
            return "Failed to process captured image"
        case .failedToSetupCamera:
            return "Failed to setup camera"
        }
    }
}

final class CameraManager: NSObject {
    
    weak var delegate: CameraManagerDelegate?
    
    private let session = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    func setupCamera(in view: UIView) {
        guard let camera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) else {
            delegate?.didFailToCapture(with: CameraError.noCameraAvailable)
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            
            try camera.lockForConfiguration()
            
            // Enable continuous autofocus
            if camera.isFocusModeSupported(.continuousAutoFocus) {
                camera.focusMode = .continuousAutoFocus
            }
            
            camera.unlockForConfiguration()
            
            session.beginConfiguration()
            
            // Remove existing inputs and outputs
            session.inputs.forEach { session.removeInput($0) }
            session.outputs.forEach { session.removeOutput($0) }
            
            // Configure session preset
            if session.canSetSessionPreset(.photo) {
                session.sessionPreset = .photo
            }
            
            if session.canAddInput(input) && session.canAddOutput(photoOutput) {
                session.addInput(input)
                session.addOutput(photoOutput)
                
                session.commitConfiguration()
                setupPreviewLayer(in: view)
                
                DispatchQueue.global(qos: .userInitiated).async {
                    self.session.startRunning()
                }
            } else {
                session.commitConfiguration()
                delegate?.didFailToCapture(with: CameraError.failedToSetupCamera)
            }
        } catch {
            session.commitConfiguration()
            delegate?.didFailToCapture(with: error)
        }
    }
    
    func updatePreviewLayerFrame(_ frame: CGRect) {
        DispatchQueue.main.async {
            self.previewLayer?.frame = frame
        }
    }
    
    func startSession() {
        DispatchQueue.global(qos: .background).async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: - Private Methods
    private func setupPreviewLayer(in view: UIView) {
        DispatchQueue.main.async {
            self.previewLayer?.removeFromSuperlayer()
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            
            view.layer.insertSublayer(previewLayer, at: 0)
            self.previewLayer = previewLayer
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            delegate?.didFailToCapture(with: error)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            delegate?.didFailToCapture(with: CameraError.failedToProcessImage)
            return
        }
        
        delegate?.didCapturePhoto(image)
    }
}
