//
//  PermissionManager.swift
//  iOS-UILib
//
//  Created by Teddy on 2020/3/18.
//  Copyright © 2020 GOONS. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreLocation

class PermissionManager: NSObject {
    
    // property
    
    var gpsUpdateSec: Double = 10
    
    var gpsIsRepeats: Bool = true
    
    // private property
    
    private weak var ownerVC: UIViewController?
    
    private lazy var captureSession = AVCaptureSession()
    
    private lazy var locationManager = CLLocationManager()
    
    private var resultImageHandler: ((UIImage) -> Void)?
    
    private var resultStringHandler: ((AVCaptureSession, String) -> Void)?
    
    private var resultLocationHandler: ((CLLocation) -> Void)?
    
    private static var currentLocation: LocaltionDetail? = nil
    
    // life cycle
    
    init(ownerVC: UIViewController, gpsUpdateSec: Double = 10, gpsIsRepeats: Bool = true) {
        
        self.ownerVC = ownerVC
        self.gpsUpdateSec = gpsUpdateSec
        self.gpsIsRepeats = gpsIsRepeats
    }
}

// MARK: - Active

extension PermissionManager {
        
    /// 開啟相機
    /// - Parameter completed: 回傳照片
    func camera(_ completed: @escaping (UIImage) -> Void) {
        
        PermissionManager.requestAuthorization(permissionType: .camera) { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .authorized:
                self.callPhoneType(with: .camera)
            case .unknow, .denied:
                self.openSettingsURL()
            }
        }
        
        resultImageHandler = completed
    }
        
    /// 掃描條碼
    /// - Parameters:
    ///   - scanAreaFrame: 掃描框架, 線條長度粗細從裡面改
    ///   - completed: 回傳 Session、掃描結果
    func scan(scanAreaFrame: CGRect, _ completed: @escaping (AVCaptureSession, String) -> Void) {
        
        PermissionManager.requestAuthorization(permissionType: .camera) { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .authorized:
                self.scanner(scanAreaFrame: scanAreaFrame)
            case .unknow, .denied:
                self.openSettingsURL()
            }
        }
        
        resultStringHandler = completed
    }
        
    /// 開啟相簿
    /// - Parameter completed: 回傳照片
    func photo(_ completed: @escaping (UIImage) -> Void) {
        
        PermissionManager.requestAuthorization(permissionType: .photo) { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .authorized:
                self.callPhoneType(with: .photo)
            case .unknow, .denied:
                self.openSettingsURL()
            }
        }

        resultImageHandler = completed
    }
        
    /// 定位
    /// - Parameters:
    ///   - locationType: 定位型別
    ///   - completed: 回傳結果
    func location(locationType: PermissionType.LocationType, _ completed: @escaping (CLLocation) -> Void) {
        
        locationManager.delegate = self
        
        PermissionManager.requestAuthorization(permissionType: .location(locationType)) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .authorized:
                self.startUpdatLocation()
            case .unknow, .denied:
                self.openSettingsURL()
            }
        }
        
        resultLocationHandler = completed
    }
}

// MARK: - Static Active

extension PermissionManager {
    
    static func requestAuthorization(permissionType: PermissionType, _ completed: @escaping (PermissionResult) -> Void) {
        
        DispatchQueue.main.async {
            
            if !PermissionDirector.isAuthorized(for: permissionType) {
                
                PermissionDirector.requestAuthorization(for: permissionType) { (result) in
                    
                    completed(result)
                }
            } else {
                
                completed(.authorized)
            }
        }
    }
}

// MARK: - Private Active

private extension PermissionManager {
    
    func openSettingsURL() {
        
        DispatchQueue.main.async {
        
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(settingsUrl)
                else { return }
            
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    enum UseType {
        
        case camera, photo
    }
    
    func callPhoneType(with type: UseType) {
        
        DispatchQueue.main.async {
            
            let picker = UIImagePickerController()
            
            switch type {
            case .camera:
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    picker.sourceType = UIImagePickerController.SourceType.camera
                    picker.allowsEditing = true // 可對照片作編輯
                    picker.delegate = self
                    self.ownerVC?.present(picker, animated: true, completion: nil)
                }
            case .photo:
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                    picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    picker.allowsEditing = true // 可對照片作編輯
                    picker.delegate = self
                    self.ownerVC?.present(picker, animated: true, completion: nil)
                }
            }
        }
    }
    
    func scanner(scanAreaFrame: CGRect) {
        
        DispatchQueue.main.async {
            
            self.captureSession = AVCaptureSession()
            
            // 影片預覽層
            let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = UIScreen.main.bounds
            self.ownerVC?.view.layer.insertSublayer(videoPreviewLayer, at: 0)
                    
            // 掃描框
            let scanView = ScanView(scanAreaFrame: scanAreaFrame, scanAreaCornerRadius: 20)
            self.ownerVC?.view.insertSubview(scanView, at: 1)
            scanView.frame = UIScreen.main.bounds
            self.ownerVC?.view.layoutIfNeeded()
            
            // 取得後置鏡頭作為擷取 session 設定輸入裝置
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                let input = try? AVCaptureDeviceInput(device: captureDevice)
                else { return }
            self.captureSession.addInput(input)

            // 初始化 AVCaptureMetadataOutput 做為擷取 session 的輸出裝置
            let captureMetadataOutput = AVCaptureMetadataOutput()
            self.captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr, .code128]
            captureMetadataOutput.rectOfInterest = videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: scanView.convert(scanAreaFrame, to: self.ownerVC?.view))
            
            self.captureSession.startRunning()
        }
    }
    
    func startUpdatLocation() {
        
        guard let _currentLocation = PermissionManager.currentLocation,
            _currentLocation.lastUpdateTime + gpsUpdateSec > Date().timeIntervalSince1970,
            !gpsIsRepeats
            else {
                
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                return
        }
        
        resultLocationHandler?(_currentLocation.localtion)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension PermissionManager: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
                
        guard let metadataObject = metadataObjects.first,
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue
            else { return }
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        resultStringHandler?(captureSession, stringValue)
    }
}


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension PermissionManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: {
            
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
                else { return }
            
            self.resultImageHandler?(image)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate

extension PermissionManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last else { return }
        resultLocationHandler?(newLocation)
        
        // 只取得一次
        if !gpsIsRepeats { manager.stopUpdatingLocation() }
        
        // 儲存位置資訊
        PermissionManager.currentLocation = LocaltionDetail(localtion: newLocation, lastUpdateTime: Date().timeIntervalSince1970)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatLocation()
        default:
            break
        }
    }
}

// MARK: - LocaltionDetail Model

struct LocaltionDetail {
    
    let localtion: CLLocation
    let lastUpdateTime: TimeInterval
}

// MARK: - ScanView

private extension PermissionManager {
    
    class ScanView: UIView {
        
        private let baseColor: UIColor = UIColor.black.withAlphaComponent(0.4)
        
        private let scanAreaFrame: CGRect
        private let scanAreaCornerRadius: CGFloat
        
        init(scanAreaFrame: CGRect, scanAreaCornerRadius: CGFloat) {
            
            self.scanAreaFrame = scanAreaFrame
            self.scanAreaCornerRadius = scanAreaCornerRadius
            
            super.init(frame: .zero)
            backgroundColor = .clear
        }
        
        required init?(coder: NSCoder) {
            
            fatalError("init(coder:) has not been implemented")
        }
        
        open override func draw(_ rect: CGRect) {
            
            super.draw(rect)
            drawScanRect()
        }
        
        private func drawScanRect() {
            
            let roundedParentPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: 0)
            let roundedPath = UIBezierPath(roundedRect: scanAreaFrame, cornerRadius: scanAreaCornerRadius)
            roundedParentPath.append(roundedPath)
            roundedParentPath.usesEvenOddFillRule = true
            
            let fillLayer = CAShapeLayer()
            fillLayer.path = roundedParentPath.cgPath
            fillLayer.fillRule = .evenOdd
            fillLayer.fillColor = baseColor.cgColor
            
            let videoPreviewLayer = AVCaptureVideoPreviewLayer()
            videoPreviewLayer.addSublayer(fillLayer)
            videoPreviewLayer.frame = layer.bounds
            layer.addSublayer(videoPreviewLayer)
        }
    }
}
