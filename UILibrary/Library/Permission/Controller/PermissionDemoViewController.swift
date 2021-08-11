//
//  PermissionDemoViewController.swift
//  UILibrary
//
//  Created by Teddy on 2021/8/10.
//

import UIKit

class PermissionDemoViewController: BaseViewController {

    // UI element
    private let permissionDemoView = PermissionDemoView()

    // property
    private lazy var permissionManager = PermissionManager(ownerVC: self, gpsIsRepeats: false)

    // Life cycle
    override func loadView() {
        
        view = permissionDemoView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configer()
    }
}

// MARK: - Configer

private extension PermissionDemoViewController {
        
    func configer() {
        
        permissionDemoView.cameraBtn.addTarget(self, action: #selector(tapCamera), for: .touchUpInside)
        permissionDemoView.scanBtn.addTarget(self, action: #selector(tapScan), for: .touchUpInside)
        permissionDemoView.scanPhotoBtn.addTarget(self, action: #selector(tapPhoto), for: .touchUpInside)
        permissionDemoView.locationBtn.addTarget(self, action: #selector(tapLocaltion), for: .touchUpInside)
    }
}

// MARK: - Action

private extension PermissionDemoViewController {

    /// 開啟相機
    @objc func tapCamera() {
        
        permissionManager.camera { (image) in
            
            print("圖片: ", image)
        }
    }
    
    /// 開始掃描 QRCode
    @objc func tapScan() {
        
        let vc = ScanViewController()
        present(vc, animated: true, completion: nil)
    }
    
    /// 從相簿掃描 QRCode
    @objc func tapPhoto() {
        
        permissionManager.photo { [weak self] (image) in
            
            guard let self = self,
                let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh]),
                let ciImage = CIImage(image: image),
                let features = detector.features(in: ciImage) as? [CIQRCodeFeature]
                else { return }
            
            let qrCodeStr = features.reduce("") { $0 + ($1.messageString ?? "") }
            
            if qrCodeStr.isEmpty { return }
            
            let alert = UIAlertController(title: "掃描結果", message: qrCodeStr, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// 取得手機位置
    @objc func tapLocaltion() {
        
        permissionManager.location(locationType: .always) { (result) in
            
            print("位置: ", result)
        }
    }
}

// MARK: - Getter

private extension PermissionDemoViewController {

}
