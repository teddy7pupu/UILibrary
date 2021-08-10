//
//  PermissionDemoView.swift
//  UILibrary
//
//  Created by Teddy on 2021/8/10.
//

import UIKit

class PermissionDemoView: UIView {

    // UI element
    let cameraBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("開啟相機", for: .normal)
        btn.backgroundColor = .black
        return btn
    }()
    
    let scanBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("掃描", for: .normal)
        btn.backgroundColor = .black
        return btn
    }()
    
    let scanPhotoBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("開啟相簿讀取QRCode", for: .normal)
        btn.backgroundColor = .black
        return btn
    }()
    
    let locationBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("開啟位置", for: .normal)
        btn.backgroundColor = .black
        return btn
    }()

    // Life cycle
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configer

extension PermissionDemoView {

    func configer() {

    }
}

// MARK: - Setup UI

private extension PermissionDemoView {

    func setupUI() {

        addSubview(cameraBtn)
        cameraBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.right.left.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        
        addSubview(scanBtn)
        scanBtn.snp.makeConstraints { (make) in
            make.top.equalTo(cameraBtn.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        
        addSubview(scanPhotoBtn)
        scanPhotoBtn.snp.makeConstraints { (make) in
            make.top.equalTo(scanBtn.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        
        addSubview(locationBtn)
        locationBtn.snp.makeConstraints { (make) in
            make.top.equalTo(scanPhotoBtn.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        
        backgroundColor = .white
    }
}
