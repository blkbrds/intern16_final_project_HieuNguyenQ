//
//  CameraController.swift
//  FinalProject
//
//  Created by hieungq on 8/21/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CameraController: NSObject {
    // MARK: - Propertis
    var captureSession: AVCaptureSession?

    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?

    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?

    var photoOutput: AVCapturePhotoOutput?

    var previewLayer: AVCaptureVideoPreviewLayer?

    var flashMode = AVCaptureDevice.FlashMode.off
    var photoCaptureCompletion: ((UIImage?, Error?) -> Void)?

    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }

    enum CameraPosition {
        case front
        case rear
    }
    // MARK: - Prepare
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            captureSession = AVCaptureSession()
        }

        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
            let cameras = (session.devices.compactMap { $0 })
            guard !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }
            for camera in cameras {
                if camera.position == .front {
                    frontCamera = camera
                }

                if camera.position == .back {
                    rearCamera = camera

                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }

        func configureDeviceInputs() throws {
            guard let captureSession = captureSession else { throw CameraControllerError.captureSessionIsMissing }

            if let rearCamera = rearCamera {
                rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                if let rearCameraInput = rearCameraInput, captureSession.canAddInput(rearCameraInput) { captureSession.addInput(rearCameraInput)
                    }
                currentCameraPosition = .rear
            } else if let frontCamera = frontCamera {
                frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                if let frontCameraInput = frontCameraInput, captureSession.canAddInput(frontCameraInput) {
                    captureSession.addInput(frontCameraInput)
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
                currentCameraPosition = .front
            } else {
                throw CameraControllerError.noCamerasAvailable
            }
        }

        func configurePhotoOutput() throws {
            guard let captureSession = captureSession else { throw CameraControllerError.captureSessionIsMissing }

            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            if let photoOutput = photoOutput, captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            captureSession.startRunning()
        }

        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            }

            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }

    func displayPreview(onView view: UIView) throws {
        guard let captureSession = captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing}

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        previewLayer?.frame = view.bounds

        if let previewLayer = previewLayer {
            view.layer.insertSublayer(previewLayer, at: 0)
        }
    }

    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition, let captureSession = captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        captureSession.beginConfiguration()
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
        case .rear:
            try switchToFrontCamera()
        }
        captureSession.commitConfiguration()
    }

    func switchToFrontCamera() throws {
        guard let captureSession = captureSession, let inputs = captureSession.inputs as? [AVCaptureInput], let rearCameraInput = rearCameraInput, inputs.contains(rearCameraInput), let frontCamera = frontCamera else { throw CameraControllerError.invalidOperation }
        captureSession.removeInput(rearCameraInput)

        frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
        if let frontCameraInput = frontCameraInput, captureSession.canAddInput(frontCameraInput) {
            captureSession.addInput(frontCameraInput)
            currentCameraPosition = .front
        } else {
            throw CameraControllerError.invalidOperation
        }
    }

    func switchToRearCamera() throws {
        guard let inputs = captureSession?.inputs, let frontCameraInput = frontCameraInput, inputs.contains(frontCameraInput), let rearCamera = rearCamera, let captureSession = captureSession else { throw CameraControllerError.invalidOperation }
        captureSession.removeInput(frontCameraInput)

        rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
        if let rearCameraInput = rearCameraInput, captureSession.canAddInput(rearCameraInput) {
            captureSession.addInput(rearCameraInput)
            currentCameraPosition = .rear
        } else {
            throw CameraControllerError.invalidOperation
        }
    }

    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }

        let settings = AVCapturePhotoSettings()
        settings.flashMode = flashMode

        photoOutput?.capturePhoto(with: settings, delegate: self)
        photoCaptureCompletion = completion
    }
}

    // MARK: - Extension
extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            photoCaptureCompletion?(nil, error)
        } else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil), let image = UIImage(data: data) {
            photoCaptureCompletion?(image, nil)
        } else {
            photoCaptureCompletion?(nil, CameraControllerError.unknown)
        }
    }
}
