//
//  ScanViewController.swift
//  iOS-UILib
//
//  Created by Teddy on 2020/3/25.
//  Copyright © 2020 GOONS. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController {

    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("關閉", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        return btn
    }()
    
    private lazy var permissionManager = PermissionManager(ownerVC: self)
    
    private var captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
        scanViewConfiger()
    }
}

// MARK: - Configer

private extension ScanViewController {
    
    func scanViewConfiger() {
        
        let scanAreaSize = CGSize(width: UIScreen.main.bounds.width - 200, height: UIScreen.main.bounds.width - 200)
        let scanAreaFrame = CGRect(x: 100, y: 100, width: scanAreaSize.width, height: scanAreaSize.height)
        
        permissionManager.scan(scanAreaFrame: scanAreaFrame) { [weak self] (captureSession, result) in
            
            guard let self = self else { return }
            
            self.captureSession = captureSession
            self.captureSession.stopRunning()
            
            let alert = UIAlertController(title: "掃描結果", message: result, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "確定", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.captureSession.startRunning()
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Active

private extension ScanViewController {
    
    @objc func onClose() {
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup UI

private extension ScanViewController {
    
    func setupUI() {
        
        view.backgroundColor = .white
                
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
        }
    }
}
