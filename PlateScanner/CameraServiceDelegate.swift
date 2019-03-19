//
//  CameraServiceDelegate.swift
//  PlateScanner
//
//  Created by Douglas Garcia on 19/03/19.
//

import AVFoundation

protocol CameraServiceDelegate {
    func captureOutput(sampleBuffer: CMSampleBuffer)
}
