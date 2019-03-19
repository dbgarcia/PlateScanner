//
//  Camera.swift
//  PlateScanner
//
//  Created by Douglas Garcia on 19/03/19.
//

import UIKit
import AVFoundation

class CameraService: NSObject {
    
    // MARK: Outlets
    
    // MARK: Properties
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var delegate: CameraServiceDelegate?
    
    var view: UIView?
    
    // MARK: Ciclo de vida
    
    override init() {
        super.init()
        
        requestCamera()
    }
}

extension CameraService {
    
    func requestCamera() {
        
        AVCaptureDevice.requestAccess(for: .video) { authorizationStatus in
            
            if !authorizationStatus {
                debugPrint("permissão negada")
            }
            
            DispatchQueue.main.async {
                self.loadCamera()
            }
        }
    }
    
    func loadCamera() {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.medium
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession.addInput(input)
            
        } catch {
            debugPrint(error.localizedDescription)
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate"))
        captureSession.addOutput(videoOutput)
        
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        
        guard let previewLayer = self.videoPreviewLayer else { return }
        guard let superView = self.view else { return }
        
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = superView.layer.bounds
        superView.layer.addSublayer(previewLayer)
        
        // Inicia video capture.
        self.captureSession.startRunning()
    }
}

extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.delegate?.captureOutput(sampleBuffer: sampleBuffer)
    }
}
