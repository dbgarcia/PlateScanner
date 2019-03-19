//
//  ViewController.swift
//  PlateScanner
//
//  Created by Douglas Garcia on 19/03/19.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var cameraServie: CameraService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraServie = CameraService()
        cameraServie?.view = self.view
        cameraServie?.delegate = self
    }
}

extension ViewController: CameraServiceDelegate {
    
    func captureOutput(sampleBuffer: CMSampleBuffer) {
        debugPrint(sampleBuffer)
    }
}

